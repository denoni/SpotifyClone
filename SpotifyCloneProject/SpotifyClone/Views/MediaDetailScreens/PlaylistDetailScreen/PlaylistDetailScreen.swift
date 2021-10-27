//
//  PlaylistDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/23/21.
//

import SwiftUI

struct PlaylistDetailScreen: View {
  var mediaDetailVM: MediaDetailViewModel
  @State var scrollViewPosition = CGFloat.zero

  init(detailScreenOrigin: MediaDetailViewModel.DetailScreenOrigin, mediaDetailVM: MediaDetailViewModel) {
    self.mediaDetailVM = mediaDetailVM
    self.mediaDetailVM.detailScreenOrigin = detailScreenOrigin
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ReadableScrollView(currentPosition: $scrollViewPosition) {
          VStack {
            // 1.8 is just a ratio that looked visually good
            TopGradient(height: geometry.size.height / 1.8)
            PlaylistDetailContent(scrollViewPosition: $scrollViewPosition)
              .padding(.top, -geometry.size.height / 1.8)
              .padding(.bottom, Constants.paddingBottomSection)
          }
        }
        TopBarWithTitle(scrollViewPosition: $scrollViewPosition,
                        title: mediaDetailVM.mainItem!.title,
                        backButtonShouldReturnTo: mediaDetailVM.detailScreenOrigin!)
      }
      .ignoresSafeArea()
    }
    .onDisappear {
      mediaDetailVM.cleanSectionFor(sectionMediaType: .playlist)
    }
  }
}

// MARK: - Detail Content

private struct PlaylistDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Binding var scrollViewPosition: CGFloat
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  /// `scale` gets the current position of the scroll view and returns a CGFloat used for animations.
  private var scale: CGFloat {
    let myScale = scrollViewPosition / UIScreen.main.bounds.height * 2
    return myScale > 0.8 ? 0.8 : myScale
  }

  private var details: SpotifyModel.PlaylistDetails { SpotifyModel.getPlaylistDetails(for: mediaDetailVM.mainItem!) }

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.spacingMedium) {
      ZStack {
        BigMediaCover(imageURL: mediaDetailVM.mainItem!.imageURL)
          .scaleEffect(1 / (scale + 1))
          .opacity(1 - Double(scale * 2 > 0.8 ? 0.8 : scale * 2))
      }
      .padding(.top, topSafeAreaSize)

      MediaTitle(mediaTitle: mediaDetailVM.mainItem!.title, lineLimit: 2)
      MediaDescription(description: details.description)
      PlaylistAuthor(mediaOwner: details.owner)

      HStack {
        VStack(alignment: .leading) {
          MediaLikesAndDuration(playlistTracks: details.playlistTracks)
          LikeAndThreeDotsIcons()
        }
        BigPlayButton()
      }
      .frame(height: 65)

      if Utility.didEverySectionLoaded(in: .playlistDetail, mediaDetailVM: mediaDetailVM) {
        TracksVerticalScrollView(tracksOrigin: .playlist(.tracksFromPlaylist))
      } else {
        HStack {
          ProgressView()
            .withSpotifyStyle(useDiscreetColors: true)
            .onAppear {
              let currentUserId = mediaDetailVM.mainVM.currentUserProfileInfo!.id
              mediaDetailVM.getPlaylistScreenData(currentUserID: currentUserId)
            }
        }.frame(maxWidth: .infinity, alignment: .center)
        Spacer()
      }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, Constants.paddingStandard)
    .padding(.vertical, Constants.paddingSmall)

  }
}

// MARK: - Preview

struct MediaDetailScreen_Previews: PreviewProvider {
  static var mainVM = MainViewModel()

  static var previews: some View {
    ZStack {
      // `detailScreenOrigin` doesn't matter on preview.
      PlaylistDetailScreen(detailScreenOrigin: .home(homeVM: HomeViewModel(mainViewModel: mainVM)),
                           mediaDetailVM: MediaDetailViewModel(mainVM: mainVM))
      VStack {
        Spacer()
        BottomBar(mainVM: mainVM, showMediaPlayer: true)
      }
    }
  }
}
