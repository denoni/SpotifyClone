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

  // This struct will be modified
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
    var details: Details
  }



  // MARK: - Sub structs

  // TODO: Support all media types
  struct Details {
    var description: String
    var href: String
    var tracks: TracksDetails
  }

  struct TracksDetails {
    var href: String
    var numberOfSongs: Int
  }

}
