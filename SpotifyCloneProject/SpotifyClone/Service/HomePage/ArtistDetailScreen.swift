//
//  ArtistDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistDetailScreen: View {
  var mediaDetailVM: MediaDetailViewModel
  @State var scrollViewPosition = CGFloat.zero
  var detailScreenOrigin: MediaDetailViewModel.DetailScreenOrigin

  init(detailScreenOrigin: MediaDetailViewModel.DetailScreenOrigin, mediaDetailVM: MediaDetailViewModel) {
    self.mediaDetailVM = mediaDetailVM
    self.detailScreenOrigin = detailScreenOrigin
    self.mediaDetailVM.detailScreenOrigin = detailScreenOrigin
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ReadableScrollView(currentPosition: $scrollViewPosition) {
          VStack {
            // 1.8 is just a ratio that looked visually good
            ArtistPictureGradient(imageURL: mediaDetailVM.mainItem!.imageURL,
                                  height: geometry.size.height / 1.8)
            ArtistDetailContent()
              .padding(.top, -geometry.size.height / 5)
              .padding(.bottom, Constants.paddingBottomSection)
            Spacer()
          }
          .frame(maxHeight: .infinity, alignment: .top)
        }
        TopBarWithTitle(scrollViewPosition: $scrollViewPosition,
                        title: mediaDetailVM.mainItem!.title,
                        backButtonWithCircleBackground: true,
                        backButtonShouldReturnTo: detailScreenOrigin)

      }.ignoresSafeArea()
    }
    .onDisappear {
      mediaDetailVM.cleanSectionFor(sectionMediaType: .artist)
    }
  }
}

// MARK: - Detail Content

struct ArtistDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var details: SpotifyModel.ArtistDetails {
    SpotifyModel.getArtistDetails(for: mediaDetailVM.mainItem!)
  }

  var body: some View {
    VStack(alignment: .center, spacing: Constants.spacingMedium) {

      BigArtistNameTitle(name: mediaDetailVM.mainItem!.title)

      HStack {
        VStack(alignment: .leading) {
          Text("\(details.followers) FOLLOWERS")
            .font(.avenir(.medium, size: Constants.fontSmall))
            .opacity(Constants.opacityStandard)
          FollowAndThreeDotsIcons(threeDotsPlacedVertically: true)
        }
        Spacer()
        BigPlayButton()
      }
      .frame(height: 65)
      .padding(.bottom, Constants.paddingStandard)

      if Utility.didEverySectionLoaded(in: .artistDetail, mediaDetailVM: mediaDetailVM) {
        VStack(spacing: 60) {
          VStack {
            Text("Popular Tracks")
              .spotifyTitle()
              .padding(.trailing, Constants.paddingLarge)
            ArtistTracks(medias: mediaDetailVM.mediaCollection[.artist(.topTracksFromArtist)]!)
          }

          VStack {
            Text("Popular Albums")
              .spotifyTitle()
              .padding(.trailing, Constants.paddingLarge)
            ArtistAlbums(medias: mediaDetailVM.mediaCollection[.artist(.albumsFromArtist)]!)
          }

          ArtistMediaHorizontalScrollView(medias: mediaDetailVM.mediaCollection[.artist(.playlistsFromArtist)]!,
                                          sectionTitle: "Featuring \(mediaDetailVM.mainItem!.title)")
            .padding(.horizontal, -Constants.paddingStandard)
        }
      } else {
        ProgressView()
          .withSpotifyStyle(useDiscreetColors: true)
          .onAppear {
            mediaDetailVM.getArtistScreenData()
          }
        Spacer()
      }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(Constants.paddingStandard)
  }
}

// MARK: - Preview

struct ArtistDetailScreen_Previews: PreviewProvider {
  static var mainVM = MainViewModel()

  static var previews: some View {
    ZStack {
      // `detailScreenOrigin` doesn't matter on preview.
      ArtistDetailScreen(detailScreenOrigin: .home(homeVM: HomeViewModel(mainViewModel: mainVM)),
                         mediaDetailVM: MediaDetailViewModel(mainVM: mainVM))
      VStack {
        Spacer()
        BottomBar(mainVM: mainVM,
                  showMediaPlayer: true)
      }
    }
  }
}
