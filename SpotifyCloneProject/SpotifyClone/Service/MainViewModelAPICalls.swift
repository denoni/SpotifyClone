//
//  MainViewModelAPICalls.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/13/21.
//

import Foundation
import Alamofire

class MainViewModelAPICalls {
  func getCurrentUserInfo(with accessToken: String,
                          completionHandler: @escaping (SpotifyModel.CurrentUserProfileInfo) -> Void) {

    let baseURL = "https://api.spotify.com/v1/me"

    var urlRequest = URLRequest(url: URL(string: baseURL)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad


    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: CurrentUserInfoResponse.self) { response in

        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let displayName = data.display_name
        let followers = data.followers.total
        let imageURL = data.images!.isEmpty ? "" : data.images![0].url
        let id = data.id

        let currentUserProfileInfo = SpotifyModel.CurrentUserProfileInfo(displayName: displayName,
                                                                         followers: followers,
                                                                         imageURL: imageURL,
                                                                         id: id)
        completionHandler(currentUserProfileInfo)
      }
  }

}
