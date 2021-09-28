//
//  AlbumDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct AlbumDetailScreen: View {
  var homeViewModel: HomeViewModel

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ScrollView(showsIndicators: false) {
          VStack {
            TopGradient(mediaDetailViewModel: homeViewModel.mediaDetailViewModel,
                        height: geometry.size.height / 1.8)
            AlbumDetailContent(homeViewModel: homeViewModel)
              .padding(.top, -geometry.size.height / 1.8)
              .padding(.bottom, 180)
          }
        }
        .disabledBouncing()
      }.ignoresSafeArea()
    }
  }
}

struct AlbumDetailContent: View {
  var homeViewModel: HomeViewModel
  var details: SpotifyModel.AlbumDetails

  init(homeViewModel: HomeViewModel) {
    self.homeViewModel = homeViewModel

    let detailsTypes = homeViewModel.mediaDetailViewModel.media!.getDetails()
    switch detailsTypes {
    case .album(let albumDetails):
      details = SpotifyModel.AlbumDetails(name: albumDetails.name,
                                          numberOfTracks: albumDetails.numberOfTracks,
                                          href: albumDetails.href,
                                          releaseDate: albumDetails.releaseDate)
    default:
      fatalError("Wrong type for PlaylistDetailScreen")
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      ZStack {
        BackButton(homeViewModel: homeViewModel)
        BigMediaCover(imageURL: homeViewModel.mediaDetailViewModel.media!.imageURL)
      }
      .padding(.top, 25)
      MediaTitle(mediaTitle: details.name)
      AlbumAuthor(authors: homeViewModel.mediaDetailViewModel.media!.author!)

      HStack {
        VStack(alignment: .leading) {
          AlbumInfo(releaseDate: details.releaseDate)
          LikeAndThreeDotsIcons()
        }
        BigPlayButton()
      }.frame(height: 65)
      
      AlbumTracksScrollView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(25)
  }
}



struct AlbumDetailScreen_Previews: PreviewProvider {
  static var mainViewModel = MainViewModel()

  static var previews: some View {
    ZStack {
      PlaylistDetailScreen(homeViewModel: HomeViewModel(mainViewModel: mainViewModel))
      VStack {
        Spacer()
        BottomBar(mainViewModel: mainViewModel, showMediaPlayer: true)
      }
    }
  }
}
