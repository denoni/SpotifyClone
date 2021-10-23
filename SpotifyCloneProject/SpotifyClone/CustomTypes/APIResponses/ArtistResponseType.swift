//
//  ArtistResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

/// # Used in
/// - `User Favorite Artists`
/// - `Artist's Top Tracks` (Used only to get the first artist)

struct ArtistResponse: Decodable {
  let items: [Artist]

  private enum CodingKeys: String, CodingKey { case items, artists }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let artists = try? container.decode([Artist].self, forKey: .artists) {
      self.items = artists
    } else if let items = try? container.decode([Artist].self, forKey: .items) {
      self.items = items
    } else {
      throw DecodingError.dataCorruptedError(forKey: .artists, in: container, debugDescription: "Unsupported JSON structure")
    }
  }
}
