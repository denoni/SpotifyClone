//
//  ArtistDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistDetailScreen: View {
  @EnvironmentObject var homeViewModel: HomeViewModel

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ScrollView(showsIndicators: false) {
          VStack {
            ZStack {
              ArtistPictureGradient(imageURL: homeViewModel.mediaDetailViewModel.media!.imageURL,
                                    height: geometry.size.height / 1.8)
              BackButtonWithCircleBackground()
            }

            ArtistDetailContent()
              .padding(.top, -geometry.size.height / 5)
              .padding(.bottom, 180)
            Spacer()
          }
          .frame(maxHeight: .infinity, alignment: .top)
        }
        .disabledBouncing()
      }.ignoresSafeArea()
    }

  }
}

struct ArtistDetailContent: View {
  @EnvironmentObject var homeViewModel: HomeViewModel

  var details: SpotifyModel.ArtistDetails {
    let detailsTypes = homeViewModel.mediaDetailViewModel.media!.getDetails()
    switch detailsTypes {
    case .artists(let artistDetails):
      return SpotifyModel.ArtistDetails(followers: artistDetails.followers,
                                           genres: artistDetails.genres,
                                           popularity: artistDetails.popularity,
                                           href: artistDetails.href)
    default:
      fatalError("Wrong type for PlaylistDetailScreen")
    }
  }

  var body: some View {
    VStack(alignment: .center, spacing: 15) {

          BigArtistNameTitle(name: homeViewModel.mediaDetailViewModel.media!.title)

          HStack {
            VStack(alignment: .leading) {
              Text("\(details.followers) FOLLOWERS")
                .font(.avenir(.medium, size: 16))
                .opacity(0.6)
              FollowAndThreeDotsIcons(threeDotsPlacedVertically: true)
            }
            Spacer()
            BigPlayButton()
          }
          .frame(height: 65)
          .padding(.bottom, 25)

      VStack(spacing: 60) {
        VStack {
          Text("Popular Tracks")
            .spotifyTitle()
          ArtistTracks()
        }

        VStack {
          Text("Popular Albums")
            .spotifyTitle()
          ArtistAlbums()
        }

        ArtistMediaHorizontalScrollView(sectionTitle: "Featuring \(homeViewModel.mediaDetailViewModel.media!.title)")
      }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(25)
  }
}



struct ArtistDetailScreen_Previews: PreviewProvider {
  static var mainViewModel = MainViewModel()

  static var previews: some View {
    ZStack {
      ArtistDetailScreen()
      VStack {
        Spacer()
        BottomBar(mainViewModel: mainViewModel, showMediaPlayer: true)
      }
    }
    .environmentObject(HomeViewModel(mainViewModel: mainViewModel))
  }
}
