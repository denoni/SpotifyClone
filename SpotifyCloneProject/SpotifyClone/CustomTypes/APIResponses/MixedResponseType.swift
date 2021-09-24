//
//  MixedResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

/// # Used in
/// - `Recently Played`
/// (p.s.  Unfortunately, however the result of the call will be composed of only tracks,
/// it doesn't use the same JSON structure as `TracksResponse`)

struct MixedResponse: Decodable {
  var items: [MixedItem]
}

struct MixedItem: Decodable {
  var track: Track
}
