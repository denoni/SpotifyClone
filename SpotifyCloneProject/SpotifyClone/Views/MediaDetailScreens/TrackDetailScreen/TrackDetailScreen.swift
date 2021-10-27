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
          .ignoresSafeArea()
        BigGradient()
          .ignoresSafeArea()
        TrackDetailContent()
          .padding(.bottom, Constants.paddingBottomSection)
      }
      .onAppear {
        // When TrackDetailScreen opens up, hide the bottomMediaPlayer
        Utility.showOrHideMediaPlayer(shouldShowMediaPlayer: false, mediaDetailVM: mediaDetailVM)

        // Gets the artist basic info(we're mainly interested in the imageURL of the artist's profile)
        MediaDetailAPICalls.UserInfoAPICalls.getArtistBasicInfo(mediaDetailVM: mediaDetailVM)
        MediaDetailAPICalls.UserInfoAPICalls.checksIfUserFollows(.track,
                                                                 mediaDetailVM: mediaDetailVM,
                                                                 itemID: mediaDetailVM.mainItem!.id)
      }
      .onDisappear {
        // When TrackDetailScreen is closed, show the bottomMediaPlayer
        Utility.showOrHideMediaPlayer(shouldShowMediaPlayer: true, mediaDetailVM: mediaDetailVM)
      }
    }
  }
}

// MARK: - Detail Content

private struct TrackDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  private var details: SpotifyModel.TrackDetails { SpotifyModel.getTrackDetails(for: mediaDetailVM.mainItem!) }
  // All versions above iPhone X will
  // end up returning false and vice versa
  private var isSmallDisplay: Bool { UIScreen.main.bounds.size.height < 750 }

  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .center) {
        SmallTopSection(albumName: details.album!.name,
                        isSmallDisplay: isSmallDisplay)
          .padding(.bottom, isSmallDisplay ? 5 : Constants.paddingSmall)
        Spacer()
        BigTrackImage(imageURL: mediaDetailVM.mainItem!.imageURL, isSmallDisplay: isSmallDisplay)
          .padding(.bottom, isSmallDisplay ? 0 : Constants.paddingSmall)
        TrackInfoSection(isExplicit: details.explicit,
                         isSmallDisplay: isSmallDisplay)
        PlayerControllerSection(isSmallDisplay: isSmallDisplay)
          .padding(.bottom, 5)
        Spacer()
        SmallBottomSection(isSmallDisplay: isSmallDisplay)
          .padding(.bottom, isSmallDisplay ? 10 : Constants.paddingSmall)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    .padding(Constants.paddingStandard)
  }
}

// MARK: - Preview

struct TrackDetailScreen_Previews: PreviewProvider {
  static var mainVM = MainViewModel()

  static var previews: some View {
    ZStack {
      TrackDetailScreen(detailScreenOrigin: .home(homeVM: HomeViewModel(mainViewModel: mainVM)),
                        mediaDetailVM: MediaDetailViewModel(mainVM: mainVM))
      VStack {
        Spacer()
      }
    }
  }
}
