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
    VStack(alignment: .center, spacing: spacingSmallItems) {
      Text(sectionTitle)
        .spotifyTitle()
        .lineLimit(1)
        .padding(.trailing, 40)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top, spacing: spacingBigItems) {
          ForEach(medias) { media in
            SmallSongItem(imageURL: media.imageURL,
                          title: media.title)
            // TODO: On tap gesture
          }
        }
        .padding(.trailing, 25)
      }
    }
    .frame(height: 250)
  }
}
