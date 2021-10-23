//
//  CurrentUserInfoResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/13/21.
//

import Foundation

class CurrentUserInfoResponse: Decodable {
  let display_name: String
  let followers: Followers
  let id: String
  let images: [CoverImage]?
}
