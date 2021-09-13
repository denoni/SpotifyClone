//
//  APIAuthentication.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import Foundation
import Alamofire

struct APIAuthentication {
  private var baseURL = "https://accounts.spotify.com/"
  private var path = "authorize"

  // SCOPE = Check available scopes on  https://developer.spotify.com/documentation/general/guides/scopes/
  // CLIENT_ID = Get yours on https://developer.spotify.com/dashboard/applications
  // REDIRECT_URI = A random website to redirect(we'll cut the connection before loading this site into the user screen) - IMPORTANT: This should be exactly equal to what you typed on your api project on spotify developer website.

  func getAuthURL(clientID: String, scope: String, redirectURI: String) -> String {
    var url = baseURL
    url += "\(path)?"

    url += "client_id=\(clientID)"
    url += "&redirect_uri=\(redirectURI)"
    url += "&scope=\(scope)"
    url += "&response_type=code"

    return url
  }
}
