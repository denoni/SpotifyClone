//
//  TrackDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct TrackDetailScreen: View {
  var mediaDetailVM: MediaDetailViewModel
  @EnvironmentObject var homeVM: HomeViewModel

  init(detailScreenOrigin: MediaDetailViewModel.DetailScreenOrigin, mediaDetailVM: MediaDetailViewModel) {
    self.mediaDetailVM = mediaDetailVM
    self.mediaDetailVM.detailScreenOrigin = detailScreenOrigin
  }

  var body: some View {
    GeometryReader { _ in
      ZStack(alignment: .center) {
        Color.spotifyDarkGray
        BigGradient()
        TrackDetailContent()
          .padding(.bottom, Constants.paddingBottomSection)
      }
      .ignoresSafeArea()
      .onAppear {
        // When TrackDetailScreen opens up, hide the bottomMediaPlayer
        switch mediaDetailVM.detailScreenOrigin {
        case .home(let homeVM):
          homeVM.mainVM.showBottomMediaPlayer = false
        case .search(let searchVM):
          searchVM.mainVM.showBottomMediaPlayer = false
        default:
          fatalError("Missing detail screen origin.")
        }

        // Gets the artist basic info(we're mainly interested in the imageURL of the artist's profile)
        mediaDetailVM.getArtistBasicInfo(mediaVM: mediaDetailVM)

        MediaDetailViewModel.UserInfoAPICalls.checksIfUserFollows(.track, mediaVM: mediaDetailVM)
      }
    }
  }
}



// MARK: - Detail Content

struct TrackDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  var details: SpotifyModel.TrackDetails { SpotifyModel.getTrackDetails(for: mediaDetailVM.mainItem!) }
  // All versions above iPhone X will
  // end up returning false and vice versa
  var isSmallDisplay: Bool { UIScreen.main.bounds.size.height < 750 }

  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .center) {
        SmallTopSection(albumName: details.album!.name,
                        isSmallDisplay: isSmallDisplay)
          .padding(.bottom, isSmallDisplay ? 0 : Constants.paddingSmall)
          .padding(.top, isSmallDisplay ? 0 : Constants.paddingSmall)
        Spacer()
        BigTrackImage(imageURL: mediaDetailVM.mainItem!.imageURL, isSmallDisplay: isSmallDisplay)
          .padding(.bottom, isSmallDisplay ? 0 : Constants.paddingSmall)
        TrackInfoSection(isExplicit: details.explicit,
                         isSmallDisplay: isSmallDisplay)
        PlayerControllerSection(isSmallDisplay: isSmallDisplay)
        Spacer()
        SmallBottomSection(isSmallDisplay: isSmallDisplay)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(Constants.paddingStandard)
    .scaledToFit()
  }
}



// MARK: - Preview

struct TrackDetailScreen_Previews: PreviewProvider {
  static var mainVM = MainViewModel()

  static var previews: some View {
    ZStack {
      TrackDetailScreen(detailScreenOrigin: .home(homeVM: HomeViewModel(mainViewModel: mainVM)), mediaDetailVM: MediaDetailViewModel(mainVM: mainVM))
      VStack {
        Spacer()
      }
    }
  }
}
