//
//  FollowedShowResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import Foundation

struct FollowedShowResponse: Decodable {
  let items: [FollowedShowItem]

  struct FollowedShowItem: Decodable {
    let show: Show
  }
}
