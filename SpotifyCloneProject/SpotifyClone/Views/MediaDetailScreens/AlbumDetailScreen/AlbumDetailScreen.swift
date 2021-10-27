//
//  AlbumDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct AlbumDetailScreen: View {
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
            TopGradient(height: geometry.size.height / 1.8)
            AlbumDetailContent(scrollViewPosition: $scrollViewPosition)
              .padding(.top, -geometry.size.height / 1.8)
              .padding(.bottom, 180)
          }
        }
        TopBarWithTitle(scrollViewPosition: $scrollViewPosition,
                        title: mediaDetailVM.mainItem!.title,
                        backButtonShouldReturnTo: mediaDetailVM.detailScreenOrigin!)

      }.ignoresSafeArea()
    }
    .onDisappear {
      mediaDetailVM.cleanSectionFor(sectionMediaType: .album)
    }
  }
}

// MARK: - Detail Content

private struct AlbumDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Binding var scrollViewPosition: CGFloat
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  private var scale: CGFloat {
    let myScale = scrollViewPosition / UIScreen.main.bounds.height * 2
    return myScale > 0.8 ? 0.8 : myScale
  }

  private var details: SpotifyModel.AlbumDetails { SpotifyModel.getAlbumDetails(for: mediaDetailVM.mainItem!) }

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.spacingMedium) {
      ZStack {
        BigMediaCover(imageURL: mediaDetailVM.mainItem!.imageURL)
          .scaleEffect(1 / (scale + 1))
          .opacity(1 - Double(scale * 2 > 0.8 ? 0.8 : scale * 2))
      }
      .padding(.top, topSafeAreaSize)

      MediaTitle(mediaTitle: details.name, lineLimit: 2)

      if Utility.didEverySectionLoaded(in: .albumDetail, mediaDetailVM: mediaDetailVM) {
        AlbumAuthor()

        HStack {
          VStack(alignment: .leading) {
            AlbumInfo(releaseDate: details.releaseDate)
            LikeAndThreeDotsIcons()
          }
          BigPlayButton()
        }.frame(height: 65)

        TracksVerticalScrollView(tracksOrigin: .album(.tracksFromAlbum))
      } else {
        HStack {
          ProgressView()
            .withSpotifyStyle(useDiscreetColors: true)
            .onAppear {
              mediaDetailVM.getAlbumScreenData()
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

struct AlbumDetailScreen_Previews: PreviewProvider {
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
