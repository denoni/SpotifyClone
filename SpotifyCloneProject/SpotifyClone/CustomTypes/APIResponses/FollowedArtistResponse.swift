//
//  FollowedUserArtistResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import Foundation

/// # Used in
/// - `MyLibraryScreen`

struct FollowedArtistResponse: Decodable {
  let artists: ArtistResponseItem

  struct ArtistResponseItem: Decodable {
    let items: [Artist]
  }
}
