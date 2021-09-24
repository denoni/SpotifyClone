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
  var items: [Artist]
}
