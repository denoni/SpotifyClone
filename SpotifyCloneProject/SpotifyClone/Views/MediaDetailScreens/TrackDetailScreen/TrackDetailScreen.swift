//
//  TrackDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct TrackDetailScreen: View {
  @EnvironmentObject var homeViewModel: HomeViewModel
  
  var body: some View {
    GeometryReader { _ in
      ZStack(alignment: .center) {
        Color.spotifyDarkGray
        BigGradient()
        TrackDetailContent()
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
  @EnvironmentObject var mediaDetailViewModel: MediaDetailViewModel

  var details: SpotifyModel.TrackDetails {
    let detailsTypes = mediaDetailViewModel.media!.getDetails()
    switch detailsTypes {
    case .tracks(let trackDetails):
      return SpotifyModel.TrackDetails(popularity: trackDetails.popularity,
                                          explicit: trackDetails.explicit,
                                          durationInMs: trackDetails.durationInMs,
                                          href: trackDetails.href,
                                          album: SpotifyModel.AlbumDetails(name: trackDetails.album!.name,
                                                                           numberOfTracks: trackDetails.album!.numberOfTracks,
                                                                           href: trackDetails.album!.href,
                                                                           releaseDate: trackDetails.album!.releaseDate))
    default:
      fatalError("Wrong type for TrackDetailScreen")
    }
  }

  var body: some View {
    VStack(alignment: .center) {
      SmallTopSection(albumName: details.album!.name)
      Spacer()
      BigTrackImage(imageURL: mediaDetailViewModel.media!.imageURL)
      TrackInfoSection(songName: mediaDetailViewModel.media!.title,
                       author: mediaDetailViewModel.media!.author!,
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
      TrackDetailScreen()
      VStack {
        Spacer()
      }
    }
  }
}
