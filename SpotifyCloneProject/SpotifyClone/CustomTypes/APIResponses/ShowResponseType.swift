//
//  ShowResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

/// # Used in
/// - `Top podcasts`

struct ShowResponse: Decodable {
  var shows: ShowItem
}

struct ShowItem: Decodable {
  var items: [Show]
}
