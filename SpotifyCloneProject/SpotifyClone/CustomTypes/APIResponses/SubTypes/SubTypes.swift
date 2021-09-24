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

struct Playlist: Decodable {
  var name: String
  var images: [CoverImage]
  var description: String
  var tracks: TracksInfo
  var owner: MediaOwner
  var href: String
  var id: String
}

struct CoverImage: Decodable {
  var url: String
}

struct TracksInfo: Decodable {
  var href: String
  var total: Int
}

struct MediaOwner: Decodable {
  var display_name: String
  var href: String
}
