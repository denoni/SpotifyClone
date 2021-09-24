//
//  APIResponseTracks.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation

// TODO: Improve and test structs
// TODO: Use less structs by trimming the data right away


// MARK: - API End Results

struct Track: Decodable {
  var name: String
  var preview_url: String?
  var album: Album
  var artists: [Artist]
  var type: String
  var id: String
}

struct Album: Decodable {
  var name: String
  var images: [CoverImage]?
  var album_type: String
  var id: String
  var artists: [Artist]
}

struct Show: Decodable {
  var name: String
  var publisher: String
  var images: [CoverImage]
  var type: String
  var id: String
}

struct Artist: Decodable {
  var name: String
  var genres: [String]?
  var images: [CoverImage]?
  var id: String
}

struct CoverImage: Decodable {
  var url: String
}



// MARK: - API Response Structs

struct MixedResponse: Decodable {
  var items: [GeneralItem]
}

struct GeneralItem: Decodable {
  var track: Track
}

struct GeneralResponse: Decodable {
  var items: [Track]
}

// -----

struct AlbumResponse: Decodable {
  var albums: AlbumItem
}

struct AlbumItem: Decodable {
  var items: [Album]
}

// -----

struct PodcastsResponse: Decodable {
  var shows: ShowItem
}

struct ShowItem: Decodable {
  var items: [Show]
}

// -----

struct TracksResponse: Decodable {
  var tracks: [Track]
}

// -----

struct PlaylistsResponse: Decodable {
  var playlists: PlaylistItems
}

struct FeaturedPlaylistsResponse: Decodable {
  var message: String
  var playlists: PlaylistItems
}

struct PlaylistItems: Decodable {
  var items: [Playlist]
}

struct Playlist: Decodable {
  var name: String
  var images: [CoverImage]
  var description: String
  var tracks: TracksInfo
  var owner: MediaOwner
  var href: String
  var id: String
}

struct TracksInfo: Decodable {
  var href: String
  var total: Int
}

struct MediaOwner: Decodable {
  var display_name: String
  var href: String
}

// -----

struct ArtistResponse: Decodable {
  var items: [Artist]
}
