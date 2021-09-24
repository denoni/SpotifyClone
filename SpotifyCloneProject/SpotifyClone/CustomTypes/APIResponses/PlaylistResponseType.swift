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
  var playlists: PlaylistItems
}

struct FeaturedPlaylistsResponse: Decodable {
  var message: String
  var playlists: PlaylistItems
}

struct PlaylistItems: Decodable {
  var items: [Playlist]
}
