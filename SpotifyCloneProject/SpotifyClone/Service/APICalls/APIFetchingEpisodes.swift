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
    case userSavedEpisodes
  }

  func getEpisode(using endPoint: EpisodesEndpointInAPI,
                  with accessToken: String,
                  limit: Int = 10,
                  offset: Int = 0,
                  completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl: String
    var thisShowID: String?

    switch endPoint {
    case .episodesFromShow(let showID):
      thisShowID = showID
      baseUrl = "https://api.spotify.com/v1/shows/\(showID)/episodes?limit=\(limit)&offset=\(offset)"
    case .userSavedEpisodes:
      baseUrl = "https://api.spotify.com/v1/me/episodes?limit=\(limit)&offset=\(offset)"
    }

    let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

    switch endPoint {
    case .episodesFromShow:
      AF.request(urlRequest)
        .validate()
        .responseDecodable(of: EpisodeResponse.self) { response in

          var episodeItems = [SpotifyModel.MediaItem]()

          let responseStatus = Utility.getResponseStatusCode(forValue: response.value, responseItemsCount: response.value?.items.count)
          guard responseStatus != .empty else { return completionHandler(episodeItems) }

          let numberOfEpisodes = response.value!.items.count

          for episodeIndex in 0 ..< numberOfEpisodes {
            let episode = response.value!.items[episodeIndex]
            episodeItems.append(parseEpisode(episode))
          }

          completionHandler(episodeItems)
        }

    case .userSavedEpisodes:
      AF.request(urlRequest)
        .validate()
        .responseDecodable(of: SavedEpisodeResponse.self) { response in

          var episodeItems = [SpotifyModel.MediaItem]()

          let responseStatus = Utility.getResponseStatusCode(forValue: response.value, responseItemsCount: response.value?.items.count)
          guard responseStatus != .empty else { return completionHandler(episodeItems) }

          let numberOfEpisodes = response.value!.items.count

          for episodeIndex in 0 ..< numberOfEpisodes {
            let episode = response.value!.items[episodeIndex].episode
            episodeItems.append(parseEpisode(episode))
          }

          completionHandler(episodeItems)
        }
    }

    func parseEpisode(_ episode: Episode) -> SpotifyModel.MediaItem {
        let title = episode.name
        let imageURL = episode.images[0].url
        let lowResImageURL = episode.images.last!.url
        let audioPreview = episode.audio_preview_url
        let id = episode.id

        let description = episode.description
        let explicit = episode.explicit
        let durationInMs = episode.duration_ms
        let releaseDate = episode.release_date

        let episodeDetails = SpotifyModel.EpisodeDetails(explicit: explicit, description: description, durationInMs: durationInMs,
                                                         releaseDate: releaseDate, id: id, showId: thisShowID)

        let podcastItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: audioPreview,
                                                 imageURL: imageURL,
                                                 lowResImageURL: lowResImageURL,
                                                 authorName: [""],
                                                 mediaType: .episode,
                                                 id: id,
                                                 details: SpotifyModel.DetailTypes.episode(episodeDetails: episodeDetails))
        return podcastItem
      }
  }

  func getEpisodeDetails(with accessToken: String,
                         episodeID: String,
                         completionHandler: @escaping (SpotifyModel.MediaItem) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/episodes/\(episodeID)"

    let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

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

        let episodeDetails = SpotifyModel.EpisodeDetails(explicit: explicit, description: description,
                                                         durationInMs: durationInMs, releaseDate: releaseDate,
                                                         id: id, showId: showId)

          let podcastItem = SpotifyModel.MediaItem(title: name,
                                                   previewURL: previewUrl,
                                                   imageURL: imageURL,
                                                   authorName: [authorName],
                                                   author: [Artist(name: authorName, images: showCoverImage, id: showId)],
                                                   mediaType: .episode,
                                                   id: id,
                                                   details: SpotifyModel.DetailTypes.episode(episodeDetails: episodeDetails))

        completionHandler(podcastItem)
      }
  }

}
