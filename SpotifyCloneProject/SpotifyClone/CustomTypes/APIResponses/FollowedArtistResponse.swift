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
  var artists: ArtistResponseItem

  struct ArtistResponseItem: Decodable {
    var items: [Artist]
  }
}
