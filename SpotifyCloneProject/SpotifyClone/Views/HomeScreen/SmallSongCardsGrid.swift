//
//  SmallSongCardsGrid.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct SmallSongCardsGrid: View {
  @ObservedObject private(set) var homeViewModel: HomeViewModel

  let sectionTitle = "Small Song Card Items"

  var sectionItems: [SpotifyMediaContent] {

    let items = homeViewModel.getItems(fromSection: sectionTitle)
    var contentFromItems = [SpotifyMediaContent]()

    for index in items.indices {
      contentFromItems.append(items[index].content)
    }

    return contentFromItems
  }

  var body: some View {
    VStack(spacing: spacingSmallItems) {
      HStack {
        Text("Good Evening")
          .spotifyTitle()
        Image("settings")
          .resizeToFit()
          .padding(5)
      }.frame(height: 30)
      buildGrid(sectionItems: sectionItems)
    }
  }

  @ViewBuilder private func buildGrid(sectionItems: [SpotifyMediaContent]) -> some View {

    VStack(spacing: spacingSmallItems) {
      HStack(spacing: spacingSmallItems) {
        SmallSongCard(image: sectionItems[0].coverImage,
                      title: sectionItems[0].title)
        SmallSongCard(image: sectionItems[1].coverImage,
                      title: sectionItems[1].title)
      }

      HStack(spacing: spacingSmallItems) {
        SmallSongCard(image: sectionItems[2].coverImage,
                      title: sectionItems[2].title)
        SmallSongCard(image: sectionItems[3].coverImage,
                      title: sectionItems[3].title)
      }

      HStack(spacing: spacingSmallItems) {
        SmallSongCard(image: sectionItems[4].coverImage,
                      title: sectionItems[4].title)
        SmallSongCard(image: sectionItems[5].coverImage,
                      title: sectionItems[5].title)
      }
    }
  }

}


