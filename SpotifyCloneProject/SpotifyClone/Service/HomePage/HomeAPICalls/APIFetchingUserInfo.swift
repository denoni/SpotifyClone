//
//  APIFetchingUserInfo.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/13/21.
//

import Foundation
import Alamofire

class APIFetchingUserInfo {

  enum ValidMediaType {
    case track
    case album
    case episode
    case playlist(userID: String)
  }

  func checksIfUserFollows(_ mediaType: ValidMediaType,
                           with accessToken: String,
                           mediaID: String,
                           completionHandler: @escaping (Bool) -> Void) {

    var mediaTypeString = ""
    var currentUserID: String?

    switch mediaType {
    case .track:
      mediaTypeString = "tracks"
    case .album:
      mediaTypeString = "albums"
    case .episode:
      mediaTypeString = "episodes"
    case .playlist(let userID):
      mediaTypeString = "playlists"
      currentUserID = userID
    }

    var baseUrl = "https://api.spotify.com/v1/me/\(mediaTypeString)/contains?ids=\(mediaID)"

    if mediaTypeString == "playlists" {
      print("\n>>> There's probably a bug in the API that for the majority of user ids, it never returns true even when user is following playlist. <<<\n")
      baseUrl = "https://api.spotify.com/v1/playlists/\(mediaID)/followers/contains?ids=\(currentUserID!)"
    }

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
