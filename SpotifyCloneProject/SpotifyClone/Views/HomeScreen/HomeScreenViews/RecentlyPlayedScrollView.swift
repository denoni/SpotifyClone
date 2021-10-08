//
//  RecentlyPlayedScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

/// `RecentlyPlayedScrollView` a smaller sized scroll view(smaller version of `BigSongCoversScrollView`).
struct RecentlyPlayedScrollView: View {
  @EnvironmentObject var homeVM: HomeViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State var medias: [SpotifyModel.MediaItem]
  
  var sectionTitle = "Recently Played"
  
  var body: some View {
    VStack(spacing: Constants.spacingSmall) {
      Text(sectionTitle)
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top, spacing: Constants.spacingLarge) {
          ForEach(medias) { media in
            SmallSongItem(imageURL: media.imageURL,
                          title: media.title)
              .onTapGesture {
                homeVM.changeSubpageTo(.trackDetail,
                                       mediaDetailVM: mediaDetailVM,
                                       withData: media)
              }
          }
        }.padding(.horizontal, Constants.paddingStandard)
      }
    }
  }
}
