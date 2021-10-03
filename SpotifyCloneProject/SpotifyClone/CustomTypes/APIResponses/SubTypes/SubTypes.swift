//
//  GeneralTypes.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

/// ## **None of those will be used directly to show UI, they're used by SpotifyModel to then show UI.**

struct Track: Decodable {
  var name: String
  var preview_url: String?
  var album: Album?
  var artists: [Artist]
  var type: String
  var id: String

  var popularity: Int?
  var explicit: Bool
  var duration_ms: Double
}

struct Album: Decodable {
  var name: String
  var images: [CoverImage]?
  var album_type: String
  var artists: [Artist]
  var id: String

  var total_tracks: Int
  var release_date: String // yyyy-MM-dd
}

struct Show: Decodable {
  var name: String
  var publisher: String
  var images: [CoverImage]
  var type: String
  var id: String

  var description: String
  var explicit: Bool
  var total_episodes: Int
}

struct Artist: Decodable {
  var name: String
  var images: [CoverImage]?
  var id: String

  var followers: Followers?
  var genres: [String]?
  var popularity: Int?
}

struct Playlist: Decodable {
  var name: String
  var images: [CoverImage]
  var id: String

  var description: String
  var tracks: TracksInfo
  var owner: MediaOwner
}

struct Episode: Decodable {
  var name: String
  var images: [CoverImage]
  var audio_preview_url: String
  var type: String
  var id: String

  var description: String
  var explicit: Bool
  var duration_ms: Double
  var release_date: String
}

struct CoverImage: Decodable {
  var url: String
}

struct TracksInfo: Decodable {
  var total: Int
  var href: String // Can't use id because some responses only return href
}

struct MediaOwner: Decodable {
  var display_name: String
  var id: String
}

struct Followers: Decodable {
  var total: Int
}
