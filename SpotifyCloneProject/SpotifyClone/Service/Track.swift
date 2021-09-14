//
//  Track.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

// TODO: Improve and test structs

import Foundation

// MARK: - Structs used to display data outside the API call.

struct TrackItem: Identifiable {
  var name: String
  var previewURL: String
  var imageURL: String
  var artist: String
  var type: String
  var id: String
}



// MARK: - Structs used to get data from the API

struct Tracks: Decodable {
  var tracks: [Track]
}

struct Track: Decodable {
  var name: String
  var preview_url: String
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
