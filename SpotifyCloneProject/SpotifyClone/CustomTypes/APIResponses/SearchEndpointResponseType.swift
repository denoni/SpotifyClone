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
    let items: [Track]
  }

  struct PlaylistSearchResponse: Decodable {
    let items: [Playlist]
  }

  struct AlbumSearchResponse: Decodable {
    let items: [Album]
  }

  struct ShowSearchResponse: Decodable {
    let items: [Show]
  }

  struct ArtistSearchResponse: Decodable {
    let items: [Artist]
  }

  struct EpisodesSearchResponse: Decodable {
    let items: [Episode]
  }
}
