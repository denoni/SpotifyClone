//
//  APIFetchingDataSearchPage.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/20/21.
//

import Foundation
import Alamofire

class APIFetchingDataSearchPage: ObservableObject {

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

        let numberOfPlaylists = data.playlists.items.count

        var playlists = [SpotifyModel.PlaylistItem]()

        guard numberOfPlaylists != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        for index in 0 ..< numberOfPlaylists {
          let sectionTitle = data.message
          let name = data.playlists.items[index].name
          let imageURL = data.playlists.items[index].images[0].url
          let id = data.playlists.items[index].id

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
