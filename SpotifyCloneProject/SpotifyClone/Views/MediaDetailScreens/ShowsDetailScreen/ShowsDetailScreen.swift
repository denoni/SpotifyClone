//
//  ShowsDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct ShowsDetailScreen: View {
  var homeViewModel: HomeViewModel

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ScrollView(showsIndicators: false) {
          VStack {
            TopGradient(mediaDetailViewModel: homeViewModel.mediaDetailViewModel,
                        height: geometry.size.height / 1.8)
            ShowsDetailContent(homeViewModel: homeViewModel)
              .padding(.top, -geometry.size.height / 1.8)
              .padding(.bottom, 180)
          }
        }
        .disabledBouncing()
      }.ignoresSafeArea()
    }
  }
}

struct ShowsDetailContent: View {
  var homeViewModel: HomeViewModel
  var details: SpotifyModel.ShowDetails

  init(homeViewModel: HomeViewModel) {
    self.homeViewModel = homeViewModel

    let detailsTypes = homeViewModel.mediaDetailViewModel.media!.getDetails()
    switch detailsTypes {
    case .shows(let showDetails):
      details = SpotifyModel.ShowDetails(description: showDetails.description,
                                         explicit: showDetails.explicit,
                                         numberOfEpisodes: showDetails.numberOfEpisodes,
                                         href: showDetails.href)
    default:
      fatalError("Wrong type for PlaylistDetailScreen")
    }
  }

  var body: some View {
    VStack(alignment: .center, spacing: 15) {
      BackButton(homeViewModel: homeViewModel)
        .padding(.top, 25)
        .padding(.bottom, 10)
      HStack(alignment: .top, spacing: 15) {
        SmallMediaCover(imageURL: homeViewModel.mediaDetailViewModel.media!.imageURL)
        VStack (alignment: .leading) {
          MediaTitle(mediaTitle: homeViewModel.mediaDetailViewModel.media!.title)
            .padding(.bottom, 5)
          ShowAuthor(authorName: homeViewModel.mediaDetailViewModel.media!.authorName.first!)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        Spacer()
      }
      .padding(.bottom, 5)

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
//          AlbumInfo(releaseDate: details.releaseDate)
          FollowAndThreeDotsIcons()
        }
        BigPlayButton()
      }.frame(height: 65)
      ShowEpisodesScrollView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(25)
  }
}



struct ShowsDetailScreen_Previews: PreviewProvider {
  static var mainViewModel = MainViewModel()

  static var previews: some View {
    ZStack {
      ShowsDetailScreen(homeViewModel: HomeViewModel(mainViewModel: mainViewModel))
      VStack {
        Spacer()
        BottomBar(mainViewModel: mainViewModel, showMediaPlayer: true)
      }
    }
  }
}
