//
//  SmallSongCardsGrid.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct SmallSongCardsGrid: View {
  @State var medias: [SpotifyModel.MediaItem]
  var numberOfItems: Range<Int> { 0 ..< medias.count / 2 }

  var body: some View {
    VStack(spacing: Constants.spacingSmall) {
      HStack {
        // TODO: Change based on user time
        Text("Good Evening")
          .spotifyTitle()
        Image("settings")
          .resizeToFit()
          .padding(5)
      }.frame(height: 30)
      buildGrid(medias: medias)
    }
  }

  @ViewBuilder private func buildGrid(medias: [SpotifyModel.MediaItem]) -> some View {

    VStack(spacing: Constants.spacingSmall) {
      ForEach(numberOfItems) { pairIndex in
        if medias.count >= 2 {
          SmallSongCardPair(imagesURL: [medias[pairIndex * 2].imageURL,
                                        medias[pairIndex * 2 + 1].imageURL],
                            titles: [medias[pairIndex * 2].title,
                                     medias[pairIndex * 2 + 1].title])
        }
      }
    }
  }

  struct SmallSongCardPair: View {
    var imagesURL: [String]
    var titles: [String]

    var body: some View {
      if imagesURL.count == 2 && titles.count == 2 {
        HStack(spacing: Constants.spacingSmall) {
          SmallSongCard(imageURL: imagesURL[0],
                        title: titles[0])
          SmallSongCard(imageURL: imagesURL[1],
                        title: titles[1])
        }
      }
    }
  }

}


