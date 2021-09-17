//
//  SmallSongCardsGrid.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct SmallSongCardsGrid: View {
  @State var medias: [SpotifyModel.MediaItem]

  var body: some View {
    VStack(spacing: spacingSmallItems) {
      HStack {
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

    // TODO: Stop populating manually

    VStack(spacing: spacingSmallItems) {
      HStack(spacing: spacingSmallItems) {
        SmallSongCard(imageURL: medias.count == 0 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : medias[0].imageURL,
                      title: medias.count == 0 ? "Loading" : medias[0].title)
        SmallSongCard(imageURL: medias.count <= 1 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : medias[1].imageURL,
                      title: medias.count <= 1 ? "Loading" : medias[1].title)
      }

      HStack(spacing: spacingSmallItems) {
        SmallSongCard(imageURL: medias.count <= 2 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : medias[2].imageURL,
                      title: medias.count <= 2 ? "Loading" : medias[2].title)
        SmallSongCard(imageURL: medias.count <= 3 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : medias[3].imageURL,
                      title: medias.count <= 3 ? "Loading" : medias[3].title)
      }

      HStack(spacing: spacingSmallItems) {
        SmallSongCard(imageURL: medias.count <= 4 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : medias[4].imageURL,
                      title: medias.count <= 4 ? "Loading" : medias[4].title)
        SmallSongCard(imageURL: medias.count <= 5 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : medias[5].imageURL,
                      title: medias.count <= 5 ? "Loading" : medias[5].title)
      }
    }
  }

}


