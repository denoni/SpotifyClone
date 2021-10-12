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

    switch endPoint {
    case .episodesFromShow(let showID):
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
          let audioPreview = episode.audio_preview_url
          let id = episode.id

          let description = episode.description
          let explicit = episode.explicit
          let durationInMs = episode.duration_ms
          let releaseDate = episode.release_date


          let podcastItem = SpotifyModel.MediaItem(title: title,
                                                   previewURL: audioPreview,
                                                   imageURL: imageURL,
                                                   authorName: [""],
                                                   mediaType: .episode,
                                                   id: id,

                                                   details: SpotifyModel.DetailTypes.episode(episodeDetails: SpotifyModel.EpisodeDetails(explicit: explicit,
                                                                                                                                         description: description,
                                                                                                                                         durationInMs: durationInMs,
                                                                                                                                         releaseDate: releaseDate,
                                                                                                                                         id: id)))
          podcastItems.append(podcastItem)
        }
        completionHandler(podcastItems)
      }
  }

}
