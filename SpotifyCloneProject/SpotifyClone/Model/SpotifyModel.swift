//
//  SpotifyModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import Foundation

struct SpotifyModel<SpotifyMediaContent> {

  // Make this a single dictionary or enum
  // (and try to set it from outside the model)
  private(set) var homeScreenMediaCollection = [String:[SpotifyMedia]]()

  init(collectionOfMedia: [String:[SpotifyMediaContent]]) {

    for (sectionTitle, sectionItems) in collectionOfMedia {
      var currentSection = [SpotifyMedia]()
      for index in 0 ..< sectionItems.count {
        let content = sectionItems[index]
        currentSection.append(SpotifyMedia(content: content,
                                           id: UUID()))
      }
      homeScreenMediaCollection[sectionTitle] = currentSection
    }
  }

  struct SpotifyMedia: Identifiable {
    var content: SpotifyMediaContent
    var id: UUID
  }

}
