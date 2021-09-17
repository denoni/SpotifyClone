//
//  BigSongCoverScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct BigSongCoversScrollView: View {
  @State var tracks: [SpotifyModel.MediaItem]
  var sectionTitle: String

  var body: some View {
    VStack(spacing: spacingSmallItems) {
      Text(sectionTitle)
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top,spacing: spacingBigItems) {
          Spacer(minLength: 5)
          ForEach(tracks) { track in
            BigSongItem(imageURL: track.imageURL,
                        title: track.title,
                        artist: track.author,
                        isArtistProfile: track.isArtist,
                        isPodcast: track.isPodcast)
          }
          Spacer(minLength: 5)
        }
      }
    }
  }
}
