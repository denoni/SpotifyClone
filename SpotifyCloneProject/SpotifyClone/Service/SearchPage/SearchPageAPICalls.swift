//
//  SearchPageAPICalls.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/26/21.
//

import Foundation
import Alamofire

class SearchPageAPICalls: ObservableObject {

  func getPlaylists(accessToken: String,
                    completionHandler: @escaping ([SpotifyModel.PlaylistItem]) -> Void) {

      let country = "US"
      let limit = 10

      let baseUrl = "https://api.spotify.com/v1/browse/featured-playlists?country=\(country)&limit=\(limit)"

    let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

      AF.request(urlRequest)
        .validate()
        .responseDecodable(of: PlaylistResponse.self) { response in

          var playlists = [SpotifyModel.PlaylistItem]()

          let responseStatus = Utility.getResponseStatusCode(forValue: response.value, responseItemsCount: response.value?.playlists.count)
          guard responseStatus != .empty else { return completionHandler(playlists) }

          let numberOfPlaylists = response.value!.playlists.count

          for index in 0 ..< numberOfPlaylists {
            let playlist = response.value!.playlists

            let sectionTitle = response.value!.message
            let name = playlist[index].name
            let imageURL = playlist[index].images[0].url
            let id = playlist[index].id

            let playlistItem = SpotifyModel.PlaylistItem(sectionTitle: sectionTitle ?? "Playlist",
                                                         name: name,
                                                         imageURL: imageURL,
                                                         id: id)
            playlists.append(playlistItem)
          }
          completionHandler(playlists)
        }
    }

}
