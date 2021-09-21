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

  struct PlaylistItem: Identifiable {
    var sectionTitle: String
    var name: String
    var imageURL: String
    var id: String
  }
  
  struct MediaItem: Identifiable {
    var title: String
    var previewURL: String
    var imageURL: String
    var author: String
    var type: String
    var isPodcast: Bool
    var isArtist: Bool
    var id: String
  }

}
