//
//  PlaylistDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/23/21.
//

import SwiftUI

struct PlaylistDetailScreen: View {
  @EnvironmentObject var homeViewModel: HomeViewModel

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ScrollView(showsIndicators: false) {
          VStack {
            TopGradient(height: geometry.size.height / 1.8)
            PlaylistDetailContent()
              .padding(.top, -geometry.size.height / 1.8)
              .padding(.bottom, 180)
          }
        }
        .disabledBouncing()

      }.ignoresSafeArea()
    }
  }
}



struct PlaylistDetailContent: View {
  @EnvironmentObject var homeViewModel: HomeViewModel

  var details: SpotifyModel.PlaylistDetails {
    let detailsTypes = homeViewModel.mediaDetailViewModel.media!.getDetails()
    switch detailsTypes {
    case .playlists(let playlistDetails):
      return SpotifyModel.PlaylistDetails(description: playlistDetails.description,
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
        VStack {
          BackButton()
          Spacer()
        }
        BigMediaCover(imageURL: homeViewModel.mediaDetailViewModel.media!.imageURL)
      }
      .padding(.top, 25)

      MediaTitle(mediaTitle: homeViewModel.mediaDetailViewModel.media!.title)
      MediaDescription(description: details.description)
      PlaylistAuthor(mediaOwner: details.owner)

      HStack {
        VStack(alignment: .leading) {
          MediaLikesAndDuration(playlistTracks: details.playlistTracks)
          LikeAndThreeDotsIcons()
        }
        BigPlayButton()
      }.frame(height: 65)

      PlaylistsScrollView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(25)
  }
}



struct MediaDetailScreen_Previews: PreviewProvider {
  static var mainViewModel = MainViewModel()

  static var previews: some View {
    ZStack {
      PlaylistDetailScreen()
      VStack {
        Spacer()
        BottomBar(mainViewModel: mainViewModel, showMediaPlayer: true)
      }
    }
  }
}
