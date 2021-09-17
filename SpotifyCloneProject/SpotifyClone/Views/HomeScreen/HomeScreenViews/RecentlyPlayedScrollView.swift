//
//  RecentlyPlayedScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

// TODO: Should accept artists and podcasts too

import SwiftUI

struct RecentlyPlayedScrollView: View {
  @State var medias: [SpotifyModel.MediaItem]

  var sectionTitle = "Recently Played"

  var body: some View {
    VStack(spacing: spacingSmallItems) {
      Text(sectionTitle)
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top, spacing: spacingBigItems) {
          Spacer(minLength: 5)
          ForEach(medias) { media in
            SmallSongItem(imageURL: media.imageURL,
                          title: media.title)
          }
          Spacer(minLength: 5)
        }
      }
    }
  }
}
