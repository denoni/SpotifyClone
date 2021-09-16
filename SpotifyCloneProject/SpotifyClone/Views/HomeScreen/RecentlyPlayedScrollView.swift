//
//  RecentlyPlayedScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

// TODO: Should accept artists and podcasts too

import SwiftUI

struct RecentlyPlayedScrollView: View {
  @State var tracks: [SpotifyModel.TrackItem]

  var sectionTitle = "Recently Played"

  var body: some View {
    VStack(spacing: spacingSmallItems) {
      Text(sectionTitle)
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top, spacing: spacingBigItems) {
          Spacer(minLength: 5)
          ForEach(tracks) { track in
            SmallSongItem(imageURL: track.imageURL,
                          title: track.name)
          }
        }
      }
    }
  }
}
