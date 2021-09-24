//
//  GeneralResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

/// # Used in
/// - `User's Favorite Tracks`
/// (p.s.  Unfortunately, however the result of the call will be composed of only tracks,
/// it doesn't use the same JSON structure as `TracksResponse`)

struct GeneralResponse: Decodable {
  var items: [Track]
}
