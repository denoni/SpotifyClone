//
//  BigSongCoverScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct BigSongCoversScrollView: View {
  @EnvironmentObject var homeVM: HomeViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  let section: HomeViewModel.Section
  var showArtistName: Bool = false
  var sectionTitle = ""
  var medias: [SpotifyModel.MediaItem] {
    homeVM.mediaCollection[section]!
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
    case .episode:
      fatalError("Type not implemented yet.")
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
                homeVM.changeSubpageTo(detailType,
                                       mediaDetailVM: mediaDetailVM,
                                       withData: media)
              }
            .buttonStyle(PlainButtonStyle())
          }
        }.padding(.horizontal, 25)
      }
    }
  }

  // If we are reaching the end of the scroll, fetch more data
  func testIfShouldFetchMoreData(basedOn media: SpotifyModel.MediaItem) {
    if medias.count > 5 {
      if media.id == medias[medias.count - 4].id {
        homeVM.fetchDataFor(section,
                                   with: homeVM.mainVM.authKey!.accessToken)
      }
    }
  }
}
