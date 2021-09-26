//
//  TrackDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct TrackDetailScreen: View {
  var homeViewModel: HomeViewModel

  var body: some View {
    GeometryReader { _ in
      ZStack(alignment: .center) {
        Color.spotifyDarkerGray
        BigGradient(mediaDetailViewModel: homeViewModel.mediaDetailViewModel)
        TrackDetailContent(homeViewModel: homeViewModel)
          .padding(.bottom, 120)
      }
      .ignoresSafeArea()
      .onAppear {
        // When TrackDetailScreen opens up, hide the bottomMediaPlayer
        homeViewModel.mainViewModel.showBottomMediaPlayer = false
      }
    }
  }
}



struct TrackDetailContent: View {
  var homeViewModel: HomeViewModel
  var details: SpotifyModel.TrackDetails

  init(homeViewModel: HomeViewModel) {
    self.homeViewModel = homeViewModel

    let detailsTypes = homeViewModel.mediaDetailViewModel.media!.getDetails()
    switch detailsTypes {
    case .tracks(let trackDetails):
      details = SpotifyModel.TrackDetails(popularity: trackDetails.popularity,
                                          explicit: trackDetails.explicit,
                                          durationInMs: trackDetails.durationInMs,
                                          href: trackDetails.href,
                                          album: SpotifyModel.AlbumDetails(name: trackDetails.album!.name,
                                                                           numberOfTracks: trackDetails.album!.numberOfTracks,
                                                                           href: trackDetails.album!.href))
    default:
      fatalError("Wrong type for TrackDetailScreen")
    }
  }

  var body: some View {
    VStack(alignment: .center) {
      SmallTopSection(homeViewModel: homeViewModel, albumName: details.album!.name)
      Spacer()
      BigTrackImage(imageURL: homeViewModel.mediaDetailViewModel.media!.imageURL)
      TrackInfoSection(songName: homeViewModel.mediaDetailViewModel.media!.title,
                       artistName: homeViewModel.mediaDetailViewModel.media!.author,
                       isLiked: true, // TODO: Use real data
                       isExplicit: details.explicit)
      SpotifySlider(durationInMs: details.durationInMs)
      PlayerControllerSection()
      Spacer()
      SmallBottomSection()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .scaledToFit()
    .padding(25)
  }
}



struct TrackDetailScreen_Previews: PreviewProvider {
  static var mainViewModel = MainViewModel()

  static var previews: some View {
    ZStack {
      TrackDetailScreen(homeViewModel: HomeViewModel(mainViewModel: mainViewModel))
      VStack {
        Spacer()
      }
    }
  }
}
