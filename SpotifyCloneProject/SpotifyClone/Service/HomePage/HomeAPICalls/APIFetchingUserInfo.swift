//
//  APIFetchingUserInfo.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/13/21.
//

import Foundation
import Alamofire

class APIFetchingUserInfo {

  func checksIfUserFollowsTrack(with accessToken: String,
                                trackID: String,
                                completionHandler: @escaping (Bool) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/me/tracks/contains?ids=\(trackID)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseJSON { json in
        do {
          let decoder = JSONDecoder()
          let response = try decoder.decode([Bool].self, from: json.data!)
          completionHandler(response.first!)
        }
        catch {
          fatalError("Error decoding response.")
        }
      }
  }


}
