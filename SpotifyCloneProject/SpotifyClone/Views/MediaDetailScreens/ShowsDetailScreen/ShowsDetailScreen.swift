//
//  ShowsDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct ShowsDetailScreen: View {
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ScrollView(showsIndicators: false) {
          VStack {
            TopGradient(height: geometry.size.height / 1.8)
            ShowsDetailContent()
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
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var details: SpotifyModel.ShowDetails { SpotifyModel.getShowDetails(for: mediaDetailVM.mainItem!) }

  var body: some View {
    VStack(alignment: .center, spacing: 15) {
      BackButton()
        .padding(.top, 25)
        .padding(.bottom, 10)
      HStack(alignment: .top, spacing: 15) {
        SmallMediaCover(imageURL: mediaDetailVM.mainItem!.imageURL)
        VStack (alignment: .leading) {
          MediaTitle(mediaTitle: mediaDetailVM.mainItem!.title)
            .padding(.bottom, 5)
          ShowAuthor(authorName: mediaDetailVM.mainItem!.authorName.first!)
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
