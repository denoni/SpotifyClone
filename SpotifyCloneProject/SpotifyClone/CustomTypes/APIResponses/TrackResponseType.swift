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
  var tracks: [Track]
}
