//
//  AlbumDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct AlbumDetailScreen: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State var scrollViewPosition = CGFloat.zero

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
                        title: mediaDetailVM.mainItem!.title)

      }.ignoresSafeArea()
    }
  }
}



// MARK: - Detail Content

struct AlbumDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Binding var scrollViewPosition: CGFloat

  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  var scale: CGFloat {
    let myScale = scrollViewPosition / UIScreen.main.bounds.height * 2
    return myScale > 0.8 ? 0.8 : myScale
  }

  var details: SpotifyModel.AlbumDetails { SpotifyModel.getAlbumDetails(for: mediaDetailVM.mainItem!) }

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      ZStack {
        BigMediaCover(imageURL: mediaDetailVM.mainItem!.imageURL)
          .scaleEffect(1 / (scale + 1))
          .opacity(1 - Double(scale * 2 > 0.8 ? 0.8 : scale * 2))
      }
      .padding(.top, topSafeAreaSize)

      MediaTitle(mediaTitle: details.name)
      AlbumAuthor(authors: mediaDetailVM.mainItem!.author!)

      HStack {
        VStack(alignment: .leading) {
          AlbumInfo(releaseDate: details.releaseDate)
          LikeAndThreeDotsIcons()
        }
        BigPlayButton()
      }.frame(height: 65)

      if didEverySectionLoaded() {
        TracksVerticalScrollView(tracksOrigin: .album(.tracksFromAlbum))
      } else {
        HStack {
          ProgressView()
            .withSpotifyStyle(useDiscreetColors: true)
            .onAppear {
              MediaDetailViewModel.AlbumAPICalls.getTracksFromAlbum(mediaVM: mediaDetailVM, loadMoreEnabled: true)
            }
        }.frame(maxWidth: .infinity, alignment: .center)
        Spacer()
      }
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, 25)
    .padding(.vertical, 15)
  }

  private func didEverySectionLoaded() -> Bool {
    for section in MediaDetailViewModel.AlbumSections.allCases {
      // If any section still loading, return false
      guard mediaDetailVM.isLoading[.album(section)] != true else {
        return false
      }
    }
    // else, return true
    return true
  }

}



// MARK: - Preview

struct AlbumDetailScreen_Previews: PreviewProvider {
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
