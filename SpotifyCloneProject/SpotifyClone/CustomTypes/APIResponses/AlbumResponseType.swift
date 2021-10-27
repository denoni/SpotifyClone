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
  let albums: [Album]

  private enum CodingKeys: String, CodingKey { case items, albums }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let albums = try? container.decode(AlbumItem.self, forKey: .albums) {
      self.albums = albums.items
    } else if let items = try? container.decode([Album].self, forKey: .items) {
      self.albums = items
    } else {
      throw DecodingError.dataCorruptedError(forKey: .albums, in: container, debugDescription: "Unsupported JSON structure")
    }
  }

  struct AlbumItem: Decodable {
    let items: [Album]
  }
}
