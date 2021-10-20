//
//  FollowedShowResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import Foundation

struct FollowedShowResponse: Decodable {
  var items: [FollowedShowItem]

  struct FollowedShowItem: Decodable {
    var show: Show
  }
}
