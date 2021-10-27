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

      var urlRequest = URLRequest(url: URL(string: baseUrl)!)
      urlRequest.httpMethod = "GET"
      urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
      urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

      AF.request(urlRequest)
        .validate()
        .responseDecodable(of: PlaylistResponse.self) { response in
          guard let data = response.value else {
            fatalError("Error receiving playlists from API.")
          }

          let numberOfPlaylists = data.playlists.count

          var playlists = [SpotifyModel.PlaylistItem]()

          guard numberOfPlaylists != 0 else {
            fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
          }

          for index in 0 ..< numberOfPlaylists {
            let sectionTitle = data.message
            let name = data.playlists[index].name
            let imageURL = data.playlists[index].images[0].url
            let id = data.playlists[index].id

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
