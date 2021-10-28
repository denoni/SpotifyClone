//
//  SmallSongCardsGrid.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct SmallSongCardsGrid: View {
  var medias: [SpotifyModel.MediaItem]
  private var numberOfItems: Range<Int> { 0 ..< medias.count / 2 }

  var body: some View {
    VStack(spacing: Constants.spacingSmall) {
      HStack {
        Text(Utility.getGreetingForCurrentTime())
          .spotifyTitle()
        Image("settings")
          .resizeToFit()
          .padding(5)
      }.frame(height: 30)
      if !medias.isEmpty {
        buildGrid(medias: medias)
      } else {
        EmptyView()
      }
    }
  }

  @ViewBuilder private func buildGrid(medias: [SpotifyModel.MediaItem]) -> some View {

    VStack(spacing: Constants.spacingSmall) {
      ForEach(numberOfItems) { pairIndex in
        if medias.count >= 2 {
          SmallSongCardPair(mediaPair: [ medias[pairIndex * 2],
                                     medias[pairIndex * 2 + 1] ])
        }
      }
    }
  }

  fileprivate struct SmallSongCardPair: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
    var mediaPair: [SpotifyModel.MediaItem]

    var body: some View {
      if mediaPair.count == 2 {
        HStack(spacing: Constants.spacingSmall) {
          SmallSongCard(imageURL: mediaPair[0].imageURL,
                        title: mediaPair[0].title)
            .onTapGesture {
              homeVM.changeSubpageTo(.trackDetail, mediaDetailVM: mediaDetailVM, withData: mediaPair[0])
            }

          SmallSongCard(imageURL: mediaPair[1].imageURL,
                        title: mediaPair[1].title)
            .onTapGesture {
              homeVM.changeSubpageTo(.trackDetail, mediaDetailVM: mediaDetailVM, withData: mediaPair[1])
            }
        }
      }
    }
  }

}
