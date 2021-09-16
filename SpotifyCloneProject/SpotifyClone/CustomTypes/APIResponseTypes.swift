//
//  APIResponseTracks.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation

// TODO: Improve and test structs
// TODO: Use less structs by trimming the data right away

// MARK: - Structs used to get data from the API

struct MixedResponse: Decodable {
  var items: [GeneralItem]
}

struct GeneralItem: Decodable {
  var track: Track
}

struct GeneralResponse: Decodable {
  var items: [Track]
}

// When the responses are just tracks

struct TracksResponse: Decodable {
  var tracks: [Track]
}

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
  var images: [CoverImage]
  var album_type: String
  var id: String
  var artists: [Artist]
}

struct Artist: Decodable {
  var name: String
  var id: String
}

struct CoverImage: Decodable {
  var height: Int
  var url: String
}
