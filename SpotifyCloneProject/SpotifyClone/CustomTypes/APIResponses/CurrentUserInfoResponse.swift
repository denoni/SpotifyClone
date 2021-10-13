//
//  CurrentUserInfoResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/13/21.
//

import Foundation

class CurrentUserInfoResponse: Decodable {
  var display_name: String
  var followers: Followers
  var id: String
  var images: [CoverImage]?
}
