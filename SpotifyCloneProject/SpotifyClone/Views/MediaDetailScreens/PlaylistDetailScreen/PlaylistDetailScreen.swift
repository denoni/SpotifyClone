//
//  PlaylistDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/23/21.
//

// TODO: Extract the custom views
// TODO: Support all media types

import SwiftUI

struct PlaylistDetailScreen: View {
  var homeViewModel: HomeViewModel

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkerGray
        ScrollView(showsIndicators: false) {
          VStack {
            TopGradient(mediaDetailViewModel: homeViewModel.mediaDetailViewModel,
                        height: geometry.size.height / 1.8)
            DetailContent(homeViewModel: homeViewModel)
              .padding(.top, -geometry.size.height / 1.8)
              .padding(.bottom, 180)
          }
        }
        .disabledBouncing()

      }.ignoresSafeArea()
    }
  }
}



struct DetailContent: View {
  var homeViewModel: HomeViewModel
  var details: SpotifyModel.PlaylistDetails

  init(homeViewModel: HomeViewModel) {
    self.homeViewModel = homeViewModel

    let detailsTypes = homeViewModel.mediaDetailViewModel.media!.getDetails()
    switch detailsTypes {
    case .playlists(let playlistDetails):
      details = SpotifyModel.PlaylistDetails(description: playlistDetails.description,
                                             playlistTracks: playlistDetails.playlistTracks,
                                             owner: playlistDetails.owner,
                                             href: playlistDetails.href)
    default:
      fatalError("Wrong type for PlaylistDetailScreen")
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      ZStack {
        BackButton(homeViewModel: homeViewModel)
        BigMediaCover(imageURL: homeViewModel.mediaDetailViewModel.media!.imageURL)
      }
      .padding(.top, 25)

      MediaDescription(description: details.description)
      PlaylistAuthor(mediaOwner: details.owner)

      HStack {
        VStack(alignment: .leading) {
          MediaLikesAndDuration(playlistTracks: details.playlistTracks)
          LikeAndThreeDotsIcons()
        }
        BigPlayButton()
      }.frame(height: 65)

      MediasScrollView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(25)
  }
}



struct MediaDetailScreen_Previews: PreviewProvider {
  static var mainViewModel = MainViewModel()

  static var previews: some View {
    ZStack {
      PlaylistDetailScreen(homeViewModel: HomeViewModel(mainViewModel: mainViewModel))
      VStack {
        Spacer()
        BottomBar(mainViewModel: mainViewModel, showMediaPlayer: true)
      }
    }
  }
}
