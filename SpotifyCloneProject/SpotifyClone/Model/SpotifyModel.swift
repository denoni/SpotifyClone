//
//  SpotifyModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import Foundation

struct SpotifyModel<SpotifyMediaContent> {

  private(set) var mediaCollection: Array<SpotifyMedia>

  init(numberOfMedias: Int, mediaContentFactory: (Int) -> SpotifyMediaContent) {
    mediaCollection = Array<SpotifyMedia>()
    for index in 0 ..< numberOfMedias {
      let content = mediaContentFactory(index)
      mediaCollection.append(SpotifyMedia(content: content, id: index))
    }
  }

  struct SpotifyMedia: Identifiable {
    var content: SpotifyMediaContent
    var id: Int
  }

}
