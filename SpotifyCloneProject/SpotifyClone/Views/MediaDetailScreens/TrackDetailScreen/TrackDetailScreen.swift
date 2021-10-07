//
//  TrackDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI
import Alamofire

struct TrackDetailScreen: View {
  @EnvironmentObject var homeVM: HomeViewModel

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
        homeVM.mainVM.showBottomMediaPlayer = false
      }
    }
  }
}



struct TrackDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  var details: SpotifyModel.TrackDetails { SpotifyModel.getTrackDetails(for: mediaDetailVM.mainItem!) }
  var isSmallDisplay: Bool { UIScreen.main.bounds.size.height < 750 }

  var body: some View {
    VStack(alignment: .center) {
      SmallTopSection(albumName: details.album!.name, isSmallDisplay: isSmallDisplay)
        .padding(.bottom, isSmallDisplay ? 0 : 15)
        .padding(.top, isSmallDisplay ? 0 : 15)
      Spacer()
      BigTrackImage(imageURL: mediaDetailVM.mainItem!.imageURL, isSmallDisplay: isSmallDisplay)
        .padding(.bottom, isSmallDisplay ? 0 : 15)
      TrackInfoSection(songName: mediaDetailVM.mainItem!.title,
                       author: mediaDetailVM.mainItem!.author!,
                       isLiked: true, // TODO: Use real data
                       isExplicit: details.explicit,
                       isSmallDisplay: isSmallDisplay)
      PlayerControllerSection(isSmallDisplay: isSmallDisplay)
      Spacer()
      SmallBottomSection(isSmallDisplay: isSmallDisplay)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .scaledToFit()
    .padding(25)
  }
}



struct TrackDetailScreen_Previews: PreviewProvider {
  static var mainVM = MainViewModel()

  static var previews: some View {
    ZStack {
      TrackDetailScreen()
      VStack {
        Spacer()
      }
    }
  }
}
