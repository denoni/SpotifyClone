//
//  SpotifyModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import Foundation

struct SpotifyModel {

  init() {
  }



  enum SpotifyMedia {
    // TODO: Create an enum to support other types of medias
  }

  // Currently just supports track
  struct TrackItem: Identifiable {
    var name: String
    var previewURL: String
    var imageURL: String
    var artist: String
    var type: String
    var id: String
  }

}
