//
//  BigSongCoverScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct BigSongCoversScrollView: View {
  @ObservedObject private(set) var homeViewModel: HomeViewModel

  let sectionTitle = "Rock Classics"


  var body: some View {
    VStack(spacing: spacingSmallItems) {
      Text(sectionTitle)
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top,spacing: spacingBigItems) {
          Spacer(minLength: 5)
          ForEach(homeViewModel.getItems(fromSection: sectionTitle)) { media in
            BigSongItem(coverImage: media.content.coverImage,
                        title: media.content.title,
                        artist: media.content.author)
          }
        }
      }
    }
  }
}
