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

    let baseUrl = "https://api.spotify.com/v1/me"

    let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: CurrentUserInfoResponse.self) { response in

        guard let data = response.value else {
          if response.response!.statusCode == 403 {
            fatalError(
            """
            You didn't add your user to the dashboard in 'https://developer.spotify.com/dashboard'.
            Check README('https://github.com/gabrieldenoni/SpotifyClone') to know how to set up the app properly.
            """)
          } else {
            fatalError("Error receiving tracks from API.")
          }
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
