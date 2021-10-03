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

struct ShowsDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Binding var scrollViewPosition: CGFloat

  var scale: CGFloat {
    let myScale = scrollViewPosition / UIScreen.main.bounds.height * 2
    return myScale > 0.8 ? 0.8 : myScale
  }

  var details: SpotifyModel.ShowDetails { SpotifyModel.getShowDetails(for: mediaDetailVM.mainItem!) }

  var body: some View {
    VStack(alignment: .center, spacing: 15) {
      HStack(alignment: .top, spacing: 15) {
        SmallMediaCover(imageURL: mediaDetailVM.mainItem!.imageURL)
        VStack (alignment: .leading) {
          MediaTitle(mediaTitle: mediaDetailVM.mainItem!.title)
            .padding(.bottom, 5)
          ShowAuthor(authorName: mediaDetailVM.mainItem!.authorName.first!)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        Spacer()
      }
      .padding(.top, 60)
      .padding(.bottom, 5)
      .scaleEffect(1 / (scale + 1))
      .opacity(1 - Double(scale * 2 > 0.8 ? 0.8 : scale * 2))
      

      MediaDescription(description: details.description)

      HStack(spacing: 0) {
        ExplicitIcon(isExplicit: details.explicit)
          .padding(.trailing, details.explicit ? 5 : 0)
          .scaleEffect(0.8)
        Text("EPISODES: \(details.numberOfEpisodes)")
          .font(.avenir(.medium, size: 14))
        Spacer()
      }
      .opacity(0.6)
      .frame(height: 25)

      HStack {
        VStack(alignment: .leading) {
          FollowAndThreeDotsIcons()
        }
        BigPlayButton()
      }.frame(height: 65)

      if didEverySectionLoaded() {
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
    .padding(25)
  }

  func didEverySectionLoaded() -> Bool {
    for section in MediaDetailViewModel.ShowsSections.allCases {
      // If any section still loading, return false
      guard mediaDetailVM.isLoading[.shows(section)] != true else {
        return false
      }
    }
    // else, return true
    return true
  }

}



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
