//
//  AlbumDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct AlbumDetailScreen: View {
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ScrollView(showsIndicators: false) {
          VStack {
            TopGradient(height: geometry.size.height / 1.8)
            AlbumDetailContent()
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
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var details: SpotifyModel.AlbumDetails {
    let detailsTypes = mediaDetailVM.mainItem!.getDetails()
      switch detailsTypes {
      case .album(let albumDetails):
        return SpotifyModel.AlbumDetails(name: albumDetails.name,
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
        VStack {
          BackButton()
          Spacer()
        }
        BigMediaCover(imageURL: mediaDetailVM.mainItem!.imageURL)
      }
      .padding(.top, 25)
      MediaTitle(mediaTitle: details.name)
      AlbumAuthor(authors: mediaDetailVM.mainItem!.author!)

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
