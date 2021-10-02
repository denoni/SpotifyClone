//
//  PlaylistDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/23/21.
//

import SwiftUI

struct PlaylistDetailScreen: View {
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
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var details: SpotifyModel.PlaylistDetails { SpotifyModel.getPlaylistDetails(for: mediaDetailVM.mainItem!) }

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      ZStack {
        VStack {
          BackButton()
          Spacer()
        }
        BigMediaCover(imageURL: mediaDetailVM.mainItem!.imageURL)
      }
      .padding(.top, 25)

      MediaTitle(mediaTitle: mediaDetailVM.mainItem!.title)
      MediaDescription(description: details.description)
      PlaylistAuthor(mediaOwner: details.owner)

      HStack {
        VStack(alignment: .leading) {
          MediaLikesAndDuration(playlistTracks: details.playlistTracks)
          LikeAndThreeDotsIcons()
        }
        BigPlayButton()
      }.frame(height: 65)
      if didEverySectionLoaded() {
        PlaylistTracksScrollView()
      } else {
        HStack {
          ProgressView()
            .withSpotifyStyle(useDiscreetColors: true)
            .onAppear {
              MediaDetailViewModel.PlaylistAPICalls.getTracksFromPlaylist(mediaVM: mediaDetailVM, loadMoreEnabled: true)
            }
        }.frame(maxWidth: .infinity, alignment: .center)
        Spacer()
      }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(25)

  }

  func didEverySectionLoaded() -> Bool {
    for section in MediaDetailViewModel.PlaylistSections.allCases {
      // If any section still loading, return false
      guard mediaDetailVM.isLoading[.playlist(section)] != true else {
        return false
      }
    }
    // else, return true
    return true
  }

}



struct MediaDetailScreen_Previews: PreviewProvider {
  static var mainVM = MainViewModel()

  static var previews: some View {
    ZStack {
      PlaylistDetailScreen()
      VStack {
        Spacer()
        BottomBar(mainVM: mainVM, showMediaPlayer: true)
      }
    }
  }
}
