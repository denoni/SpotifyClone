//
//  APIResponseTracks.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

// TODO: Improve and test structs

import Foundation

// MARK: - Structs used to display data outside the API call.



// MARK: - Structs used to get data from the API

struct TracksResponse: Decodable {
  var tracks: [TrackResponse]
}

struct TrackResponse: Decodable {
  var name: String
  var preview_url: String?
  var album: AlbumResponse
  var artists: [ArtistResponse]
  var type: String
  var id: String
}

struct AlbumResponse: Decodable {
  var name: String
  var images: [CoverImageResponse]
  var album_type: String
  var id: String
  var artists: [ArtistResponse]
}

struct ArtistResponse: Decodable {
  var name: String
  var id: String
}

struct CoverImageResponse: Decodable {
  var height: Int
  var url: String
}
