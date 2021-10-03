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
      print(showID)
      baseUrl = "https://api.spotify.com/v1/shows/\(showID)/episodes?limit=\(limit)&offset=\(offset)"
    }



    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: EpisodeResponse.self) { response in

        debugPrint(response.debugDescription)

        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfItems = data.items.count


        guard numberOfItems != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        var podcastItems = [SpotifyModel.MediaItem]()

        for itemIndex in 0 ..< numberOfItems {
          let title = data.items[itemIndex].name
          let imageURL = data.items[itemIndex].images[0].url
          let audioPreview = data.items[itemIndex].audio_preview_url
          let id = data.items[itemIndex].id

          let description = data.items[itemIndex].description
          let explicit = data.items[itemIndex].explicit
          let durationInMs = data.items[itemIndex].duration_ms
          let releaseDate = data.items[itemIndex].release_date


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
