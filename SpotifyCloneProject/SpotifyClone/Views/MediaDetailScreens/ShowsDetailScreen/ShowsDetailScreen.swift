//
//  ShowsDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct ShowsDetailScreen: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State var scrollViewPosition = CGFloat.zero

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ReadableScrollView(currentPosition: $scrollViewPosition) {
          VStack {
            TopGradient(height: geometry.size.height / 1.8)
            ShowsDetailContent(scrollViewPosition: $scrollViewPosition)
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

struct ShowsDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Binding var scrollViewPosition: CGFloat
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  var scale: CGFloat {
    let myScale = scrollViewPosition / UIScreen.main.bounds.height * 2
    return myScale > 0.8 ? 0.8 : myScale
  }

  var details: SpotifyModel.ShowDetails { SpotifyModel.getShowDetails(for: mediaDetailVM.mainItem!) }

  var body: some View {
    VStack(alignment: .center, spacing: Constants.spacingMedium) {
      HStack(alignment: .top, spacing: Constants.spacingMedium) {
        SmallMediaCover(imageURL: mediaDetailVM.mainItem!.imageURL)
        VStack (alignment: .leading) {
          MediaTitle(mediaTitle: mediaDetailVM.mainItem!.title)
            .padding(.bottom, 5)
          ShowAuthor(authorName: mediaDetailVM.mainItem!.authorName.first!)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        Spacer()
      }
      .padding(.top, topSafeAreaSize)
      .padding(.top, Constants.paddingStandard)
      .padding(.bottom, 5)
      // Animate the opacity and size based on `scale`
      // (originated from the current position of the scroll view)
      .scaleEffect(1 / (scale + 1))
      .opacity(1 - Double(scale * 2 > 0.8 ? 0.8 : scale * 2))
      

      MediaDescription(description: details.description)

      NumberOfEpisodes(isExplicit: details.explicit, numberOfEpisodes: details.numberOfEpisodes)

      HStack {
        VStack(alignment: .leading) {
          FollowAndThreeDotsIcons()
        }
        BigPlayButton()
      }.frame(height: 65)

      if Utility.didEverySectionLoaded(in: .showDetail, mediaDetailVM: mediaDetailVM) {
        ShowEpisodesScrollView()
      } else {
        HStack {
          ProgressView()
            .withSpotifyStyle(useDiscreetColors: true)
            .onAppear {
              MediaDetailViewModel.ShowsAPICalls.getEpisodesFromShows(mediaVM: mediaDetailVM, loadMoreEnabled: true)
            }
        }
      }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(Constants.paddingStandard)
  }

  struct NumberOfEpisodes: View {
    var isExplicit: Bool
    var numberOfEpisodes: Int

    var body: some View {
      HStack(spacing: 0) {
        ExplicitIcon(isExplicit: isExplicit)
          .padding(.trailing, isExplicit ? 5 : 0)
          .scaleEffect(0.8)
        Text("EPISODES: \(numberOfEpisodes)")
          .font(.avenir(.medium, size: Constants.fontXSmall))
        Spacer()
      }
      .opacity(Constants.opacityHigh)
      .frame(height: Constants.paddingStandard)
    }
  }
}



// MARK: - Preview

struct ShowsDetailScreen_Previews: PreviewProvider {
  static var mainVM = MainViewModel()

  static var previews: some View {
    ZStack {
      ShowsDetailScreen()
      VStack {
        Spacer()
        BottomBar(mainVM: mainVM, showMediaPlayer: true)
      }
    }
  }
}
