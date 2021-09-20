//
//  BigSongCoverScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct BigSongCoversScrollView: View {
  @StateObject var homeViewModel: HomeViewModel
  let section = HomeViewModel.Section.newReleases
  var medias: [SpotifyModel.MediaItem] {
    homeViewModel.medias[HomeViewModel.Section.newReleases.rawValue]!
  }

  
  var body: some View {
    VStack(spacing: spacingSmallItems) {
      Text(section.rawValue)
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top,spacing: spacingBigItems) {
          ForEach(medias) { media in
            BigSongItem(imageURL: media.imageURL,
                        title: media.title,
                        artist: media.author,
                        isArtistProfile: media.isArtist,
                        isPodcast: media.isPodcast)
              .onAppear {
                if medias.count > 6 {
                  if media.id == medias[medias.count - 4].id {
                    homeViewModel.getNewReleases(accessToken: homeViewModel.mainViewModel.authKey!.accessToken,
                                                 loadingMore: true)
                  }
                }
              }
          }
        }.padding(.horizontal, 25)
      }
    }
  }
}
