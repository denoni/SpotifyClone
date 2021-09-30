//
//  BigSongCoverScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct BigSongCoversScrollView: View {
  @EnvironmentObject var homeViewModel: HomeViewModel
  @EnvironmentObject var mediaDetailViewModel: MediaDetailViewModel

  let section: HomeViewModel.Section
  var showArtistName: Bool = false
  var sectionTitle = ""
  var medias: [SpotifyModel.MediaItem] {
    homeViewModel.mediaCollection[section]!
  }

  var detailType: HomeViewModel.HomeSubpage {
    switch medias.first!.mediaType {
    case .playlist:
      return HomeViewModel.HomeSubpage.playlistDetail
    case .track:
      return HomeViewModel.HomeSubpage.trackDetail
    case .album:
      return HomeViewModel.HomeSubpage.albumDetail
    case .show:
      return HomeViewModel.HomeSubpage.showDetail
    case .artist:
      return HomeViewModel.HomeSubpage.artistDetail
    }
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
                        artist: showArtistName ? media.authorName.joined(separator: ", ") : "",
                        mediaType: media.mediaType)
              .onAppear { testIfShouldFetchMoreData(basedOn: media) }
              .onTapGesture {
                homeViewModel.changeSubpageTo(detailType,
                                              mediaDetailViewModel: mediaDetailViewModel,
                                              withData: media)
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
