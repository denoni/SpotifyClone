//
//  AlbumResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

/// # Used in
/// - `New Releases`

struct AlbumResponse: Decodable {
  var albums: AlbumItem
}

struct AlbumItem: Decodable {
  var items: [Album]
}
