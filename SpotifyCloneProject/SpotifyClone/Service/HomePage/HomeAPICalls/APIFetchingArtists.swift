//
//  APIFetchingArtists.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import Foundation
import Alamofire

class APIFetchingArtists {

  enum ArtistsEndpointInAPI {
    case userFavoriteArtists
  }

  func getArtist(using endPoint: ArtistsEndpointInAPI,
                   with accessToken: String,
                   limit: Int = 10,
                   completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl: String

    switch endPoint {
    case .userFavoriteArtists:
      baseUrl = "https://api.spotify.com/v1/me/top/artists?limit=\(limit)"
    }

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: ArtistResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfArtists = data.items.count

        var artists = [SpotifyModel.MediaItem]()

        guard numberOfArtists != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        for itemIndex in 0 ..< numberOfArtists {
          let title = data.items[itemIndex].name
          let imageURL = data.items[itemIndex].images?[0].url
          let id = data.items[itemIndex].id

          let artistItem = SpotifyModel.MediaItem(title: title,
                                                  previewURL: "",
                                                  imageURL: imageURL ?? "",
                                                  authorName: [title],
                                                  mediaType: .artist,
                                                  id: id,

                                                  // TODO: Put real data from api

                                                  details: SpotifyModel.DetailTypes.artists(artistDetails: SpotifyModel.ArtistDetails(followers: 0,
                                                                                                                                      genres: [""],
                                                                                                                                      popularity: 0,
                                                                                                                                      href: "")))
          artists.append(artistItem)
        }
        completionHandler(artists)
      }
  }
}
