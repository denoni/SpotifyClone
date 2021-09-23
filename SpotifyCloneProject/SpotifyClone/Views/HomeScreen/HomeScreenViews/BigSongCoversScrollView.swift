//
//  BigSongCoverScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct BigSongCoversScrollView: View {
  @StateObject var homeViewModel: HomeViewModel
  let section: HomeViewModel.Section
  var sectionTitle = ""
  var medias: [SpotifyModel.MediaItem] {
    homeViewModel.mediaCollection[section]!
  }

  
  var body: some View {
    VStack(spacing: spacingSmallItems) {
      Text(sectionTitle.isEmpty ? section.rawValue : sectionTitle)
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top,spacing: spacingBigItems) {
          ForEach(medias) { media in
            BigSongItem(imageURL: media.imageURL,
                        title: media.title,
                        artist: "",
                        isArtistProfile: media.isArtist,
                        isPodcast: media.isPodcast)
              .onAppear { testIfShouldFetchMoreData(basedOn: media) }
              .onTapGesture {
                print("aaa")
                homeViewModel.changeSubpageTo(.mediaDetail)
              }
            .buttonStyle(PlainButtonStyle())
          }
        }.padding(.horizontal, 25)
      }
    }
  }

  func testIfShouldFetchMoreData(basedOn media: SpotifyModel.MediaItem) {
    if medias.count > 5 {
      if media.id == medias[medias.count - 4].id {
        homeViewModel.fetchDataFor(section,
                                   with: homeViewModel.mainViewModel.authKey!.accessToken)
      }
    }
  }
}
