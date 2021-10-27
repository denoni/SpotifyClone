//
//  PlaylistResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

/// # Used in
/// - `Featured Playlists`
/// - Any playlist get using the search endpoint of the API with a selected type of playlist
/// (e.g.  `Featured Playlists`,  `Playlist Year Rewind`, `Playlist This is X`)

struct PlaylistResponse: Decodable {
  var message: String?
  let playlists: [Playlist]

  private enum CodingKeys: String, CodingKey { case items, playlists }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let items = try? container.decode([Playlist].self, forKey: .items) {
      self.playlists = items
    } else if let playlists = try? container.decode(PlaylistItems.self, forKey: .playlists) {
      self.playlists = playlists.items
    } else {
      throw DecodingError.dataCorruptedError(forKey: .items, in: container, debugDescription: "Unsupported JSON structure")
    }
  }

  private struct PlaylistItems: Decodable {
    let items: [Playlist]
  }
}
