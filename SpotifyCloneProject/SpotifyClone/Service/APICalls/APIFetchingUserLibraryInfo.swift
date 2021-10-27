//
//  APIFetchingUserLibraryInfo.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/27/21.
//

import Foundation
import Alamofire

class APIFetchingUserLibraryInfo {

  func getNumberOfLikedSongs(with accessToken: String, completionHandler: @escaping (Int) -> Void) {
    let baseUrl = "https://api.spotify.com/v1/me/tracks?limit=1"

    let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: NumberOfSavedItemsResponse.self) { response in
        completionHandler(response.value!.total)
      }
  }

  func getNumberOfSavedEpisodes(with accessToken: String, completionHandler: @escaping (Int) -> Void) {
    let baseUrl = "https://api.spotify.com/v1/me/episodes?limit=1"

    let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: NumberOfSavedItemsResponse.self) { response in
        completionHandler(response.value!.total)
      }
  }

}
