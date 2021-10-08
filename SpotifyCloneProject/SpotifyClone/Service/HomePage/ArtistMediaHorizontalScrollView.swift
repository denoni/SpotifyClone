//
//  ArtistMediaHorizontalScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistMediaHorizontalScrollView: View {
  @State var medias: [SpotifyModel.MediaItem]
  var sectionTitle: String

  var body: some View {
    VStack(alignment: .center, spacing: Constants.spacingSmall) {
      Text(sectionTitle)
        .spotifyTitle()
        .lineLimit(1)
        .padding(.trailing, Constants.paddingLarge)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top, spacing: Constants.spacingLarge) {
          ForEach(medias) { media in
            SmallSongItem(imageURL: media.imageURL,
                          title: media.title)
            // TODO: On tap gesture
          }
        }
        .padding(.trailing, Constants.paddingStandard)
      }
    }
    .frame(height: 250)
  }
}
