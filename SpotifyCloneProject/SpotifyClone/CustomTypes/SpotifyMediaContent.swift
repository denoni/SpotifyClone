//
//  SpotifyMediaContent.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import SwiftUI

struct SpotifyMediaContent {
  var title: String
  var author: String
  var coverImage: Image
  var isPodcast: Bool = false

  init(title: String,
       author: String,
       coverImage: Image,
       isPodcast: Bool = false) {
    self.title = title
    self.author = author
    self.coverImage = coverImage
    self.isPodcast = isPodcast
  }
}
