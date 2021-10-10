//
//  SearchEndpointResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import Foundation

/// # Used in any response from the Search endpoint of the API

struct SearchEndpointResponse: Decodable {
  let tracks: TrackSearchResponse?
  let playlists: PlaylistSearchResponse?
  let albums: AlbumSearchResponse?
  let shows: ShowSearchResponse?
  let artists: ArtistSearchResponse?
  let episodes: EpisodesSearchResponse?

  struct TrackSearchResponse: Decodable {
    var items: [Track]
  }

  struct PlaylistSearchResponse: Decodable {
    var items: [Playlist]
  }

  struct AlbumSearchResponse: Decodable {
    var items: [Album]
  }

  struct ShowSearchResponse: Decodable {
    var items: [Show]
  }

  struct ArtistSearchResponse: Decodable {
    var items: [Artist]
  }

  struct EpisodesSearchResponse: Decodable {
    var items: [Episode]
  }
}
