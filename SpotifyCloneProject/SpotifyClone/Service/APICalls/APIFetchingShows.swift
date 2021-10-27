//
//  APIFetchingShows.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import Foundation
import Alamofire

class APIFetchingShows {

  enum ShowsEndpointInAPI {
    case topPodcasts
    case followedPodcasts
  }

  func getShow(using endPoint: ShowsEndpointInAPI,
               with accessToken: String,
               limit: Int = 10,
               offset: Int = 0,
               completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl: String

    switch endPoint {
    case .topPodcasts:
      let termSearch = "spotify+exclusive"
      let type = "show"
      let market = "US"
      baseUrl = "https://api.spotify.com/v1/search?q=\(termSearch)&type=\(type)&market=\(market)&limit=\(limit)&offset=\(offset)"

      let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

      AF.request(urlRequest)
        .validate()
        .responseDecodable(of: ShowResponse.self) { response in

          var podcastItems = [SpotifyModel.MediaItem]()

          let responseStatus = Utility.getResponseStatusCode(forValue: response.value,
                                                             responseItemsCount: response.value?.shows.items.count)
          guard responseStatus != .empty else { return completionHandler(podcastItems) }

          let numberOfItems = response.value!.shows.items.count

          for showIndex in 0 ..< numberOfItems {
            let show = response.value!.shows.items[showIndex]
            podcastItems.append(self.parseShowData(show))
          }

          completionHandler(podcastItems)
        }

    case .followedPodcasts:
      baseUrl = "https://api.spotify.com/v1/me/shows"

      let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

      AF.request(urlRequest)
        .validate()
        .responseDecodable(of: FollowedShowResponse.self) { response in

          var podcastItems = [SpotifyModel.MediaItem]()

          let responseStatus = Utility.getResponseStatusCode(forValue: response.value, responseItemsCount: response.value?.items.count)
          guard responseStatus != .empty else { return completionHandler(podcastItems) }

          let numberOfItems = response.value!.items.count

          for showIndex in 0 ..< numberOfItems {
            let show = response.value!.items[showIndex].show
            podcastItems.append(self.parseShowData(show))
          }

          completionHandler(podcastItems)
        }
    }
  }

  // MARK: - Auxiliary functions

  private func parseShowData(_ show: Show) -> SpotifyModel.MediaItem {
    let title = show.name
    let imageURL = show.images[0].url
    let authorName = show.publisher
    let id = show.id

    let description = show.description
    let explicit = show.explicit
    let showID = show.id
    let numberOfEpisodes = show.total_episodes

    let showDetails = SpotifyModel.ShowDetails(description: description, explicit: explicit,
                                               numberOfEpisodes: numberOfEpisodes, id: showID)

    let podcastItem = SpotifyModel.MediaItem(title: title,
                                             previewURL: "",
                                             imageURL: imageURL,
                                             authorName: [authorName],
                                             mediaType: .show,
                                             id: id,
                                             details: SpotifyModel.DetailTypes.shows(showDetails: showDetails))
    return podcastItem
  }

}
