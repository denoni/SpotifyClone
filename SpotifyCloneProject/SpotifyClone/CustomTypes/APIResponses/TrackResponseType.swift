//
//  TrackResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

/// # Used in
/// - `Artist's Top Tracks`

struct TrackResponse: Decodable {
  let tracks: [Track]

  private enum CodingKeys: String, CodingKey { case items, tracks }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let tracks = try? container.decode([Track].self, forKey: .items) {
      self.tracks = tracks
    } else if let tracks = try? container.decode([Track].self, forKey: .tracks) {
      self.tracks = tracks
    } else if let items = try? container.decode([TrackResponseItem].self, forKey: .items) {
      self.tracks = items.map(\.track)
    } else {
      throw DecodingError.dataCorruptedError(forKey: .items, in: container, debugDescription: "Unsupported JSON structure")
    }
  }

  struct TrackResponseItem: Decodable {
    let track: Track
  }
}
