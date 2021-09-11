//
//  BigSongCoverScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct BigSongCoversScrollView: View {
  @ObservedObject private(set) var homeViewModel: HomeViewModel

  var body: some View {
    VStack(spacing: spacingSmallItems) {
      Text("Rock Classics")
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top,spacing: spacingBigItems) {
          Spacer(minLength: 5)
          ForEach(homeViewModel.mediaCollection) { media in
            BigSongItem(coverImage: media.content.coverImage,
                        title: media.content.title,
                        artist: media.content.author)
          }
        }
      }
    }
  }
}
