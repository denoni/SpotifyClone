//
//  AuthKey.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import Foundation

struct AuthKey: Decodable {
  var accessToken: String
  var refreshToken: String
  var scope: String

  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case scope
  }
}
