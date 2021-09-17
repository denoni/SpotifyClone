//
//  SmallSongCardsGrid.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct SmallSongCardsGrid: View {
  @State var tracks: [SpotifyModel.MediaItem]

  var body: some View {
    VStack(spacing: spacingSmallItems) {
      HStack {
        Text("Good Evening")
          .spotifyTitle()
        Image("settings")
          .resizeToFit()
          .padding(5)
      }.frame(height: 30)
      buildGrid(tracks: tracks)
    }
  }

  @ViewBuilder private func buildGrid(tracks: [SpotifyModel.MediaItem]) -> some View {

    // TODO: Stop populating manually

    VStack(spacing: spacingSmallItems) {
      HStack(spacing: spacingSmallItems) {
        SmallSongCard(imageURL: tracks.count == 0 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : tracks[0].imageURL,
                      title: tracks.count == 0 ? "Loading" : tracks[0].title)
        SmallSongCard(imageURL: tracks.count <= 1 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : tracks[1].imageURL,
                      title: tracks.count <= 1 ? "Loading" : tracks[1].title)
      }

      HStack(spacing: spacingSmallItems) {
        SmallSongCard(imageURL: tracks.count <= 2 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : tracks[2].imageURL,
                      title: tracks.count <= 2 ? "Loading" : tracks[2].title)
        SmallSongCard(imageURL: tracks.count <= 3 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : tracks[3].imageURL,
                      title: tracks.count <= 3 ? "Loading" : tracks[3].title)
      }

      HStack(spacing: spacingSmallItems) {
        SmallSongCard(imageURL: tracks.count <= 4 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : tracks[4].imageURL,
                      title: tracks.count <= 4 ? "Loading" : tracks[4].title)
        SmallSongCard(imageURL: tracks.count <= 5 ? "https://s3-us-west-2.amazonaws.com/jmiller-projects/playedmost/spotify-placeholder-trimmable.png" : tracks[5].imageURL,
                      title: tracks.count <= 5 ? "Loading" : tracks[5].title)
      }
    }
  }

}


