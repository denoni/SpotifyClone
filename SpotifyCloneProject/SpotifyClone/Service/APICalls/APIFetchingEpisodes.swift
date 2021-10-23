//
//  APIFetchingEpisodes.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/2/21.
//

import Foundation
import Alamofire

class APIFetchingEpisodes {

  enum EpisodesEndpointInAPI {
    case episodesFromShow(showID: String)
  }

  func getEpisode(using endPoint: EpisodesEndpointInAPI,
                  with accessToken: String,
                  limit: Int = 10,
                  offset: Int = 0,
                  completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl: String
    let thisShowID: String

    switch endPoint {
    case .episodesFromShow(let showID):
      thisShowID = showID
      baseUrl = "https://api.spotify.com/v1/shows/\(showID)/episodes?limit=\(limit)&offset=\(offset)"
    }

    var podcastItems = [SpotifyModel.MediaItem]()

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: EpisodeResponse.self) { response in

        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfEpisodes = data.items.count


        guard numberOfEpisodes != 0 else {
          completionHandler(podcastItems)
          print("The API response was corrects but empty. We'll just return []")
          return
        }

        for episodeIndex in 0 ..< numberOfEpisodes {
          let episode = data.items[episodeIndex]

          let title = episode.name
          let imageURL = episode.images[0].url
          let lowResImageURL = episode.images.last!.url
          let audioPreview = episode.audio_preview_url
          let id = episode.id

          let description = episode.description
          let explicit = episode.explicit
          let durationInMs = episode.duration_ms
          let releaseDate = episode.release_date

          print(episode.images.count)
          print(episode.images)

          let podcastItem = SpotifyModel.MediaItem(title: title,
                                                   previewURL: audioPreview,
                                                   imageURL: imageURL,
                                                   lowResImageURL: lowResImageURL,
                                                   authorName: [""],
                                                   mediaType: .episode,
                                                   id: id,
                                                   details: SpotifyModel.DetailTypes.episode(episodeDetails: SpotifyModel.EpisodeDetails(explicit: explicit,
                                                                                                                                         description: description,
                                                                                                                                         durationInMs: durationInMs,
                                                                                                                                         releaseDate: releaseDate,
                                                                                                                                         id: id,
                                                                                                                                         showId: thisShowID)))
          podcastItems.append(podcastItem)
        }
        completionHandler(podcastItems)
      }
  }


  func getEpisodeDetails(with accessToken: String,
                         episodeID: String,
                         completionHandler: @escaping (SpotifyModel.MediaItem) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/episodes/\(episodeID)"


    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: EpisodeDetailsResponse.self) { response in

        guard let episode = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let previewUrl = episode.audio_preview_url
        let description = episode.description
        let durationInMs = episode.duration_ms
        let explicit = episode.explicit
        let id = episode.id
        let imageURL = episode.images.isEmpty ? "" : episode.images.first!.url
        let name = episode.name
        let releaseDate = episode.release_date

        let show = episode.show
        let authorName = show.publisher
        let showCoverImage = show.images
        let showId = show.id

          let podcastItem = SpotifyModel.MediaItem(title: name,
                                                   previewURL: previewUrl,
                                                   imageURL: imageURL,
                                                   authorName: [authorName],
                                                   author: [Artist(name: authorName,
                                                                   images: showCoverImage,
                                                                   id: showId)],
                                                   mediaType: .episode,
                                                   id: id,
                                                   details: SpotifyModel.DetailTypes.episode(episodeDetails:
                                                                                              SpotifyModel.EpisodeDetails(explicit: explicit,
                                                                                                                          description: description,
                                                                                                                          durationInMs: durationInMs,
                                                                                                                          releaseDate: releaseDate,
                                                                                                                          id: id,
                                                                                                                          showId: showId)))


        completionHandler(podcastItem)
      }
  }

}
