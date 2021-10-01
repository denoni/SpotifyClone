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
    }



    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: ShowResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfItems = data.shows.items.count


        guard numberOfItems != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        var podcastItems = [SpotifyModel.MediaItem]()

        for itemIndex in 0 ..< numberOfItems {
          let title = data.shows.items[itemIndex].name
          let imageURL = data.shows.items[itemIndex].images[0].url
          let authorName = data.shows.items[itemIndex].publisher
          let id = data.shows.items[itemIndex].id

          let description = data.shows.items[itemIndex].description
          let explicit = data.shows.items[itemIndex].explicit
          let showID = data.shows.items[itemIndex].id
          let numberOfEpisodes = data.shows.items[itemIndex].total_episodes

          let podcastItem = SpotifyModel.MediaItem(title: title,
                                                   previewURL: "",
                                                   imageURL: imageURL,
                                                   authorName: [authorName],
                                                   mediaType: .show,
                                                   id: id,

                                                   details: SpotifyModel.DetailTypes.shows(showDetails: SpotifyModel.ShowDetails(description: description,
                                                                                                                                 explicit: explicit,
                                                                                                                                 numberOfEpisodes: numberOfEpisodes,
                                                                                                                                 id: showID)))
          podcastItems.append(podcastItem)
        }
        completionHandler(podcastItems)
      }
  }

}
