//
//  ArtistDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistDetailScreen: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ScrollView(showsIndicators: false) {
          VStack {
            ZStack {
              ArtistPictureGradient(imageURL: mediaDetailVM.mainItem!.imageURL,
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
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var details: SpotifyModel.ArtistDetails { SpotifyModel.getArtistDetails(for: mediaDetailVM.mainItem!) }

  var body: some View {
    VStack(alignment: .center, spacing: 15) {

          BigArtistNameTitle(name: mediaDetailVM.mainItem!.title)

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

      if didEverySectionLoaded() {
        VStack(spacing: 60) {
          VStack {
            Text("Popular Tracks")
              .spotifyTitle()
              .padding(.trailing, 40)
            ArtistTracks(medias: mediaDetailVM.mediaCollection[.topTracksFromArtist]!)
          }

          VStack {
            Text("Popular Albums")
              .spotifyTitle()
              .padding(.trailing, 40)
            ArtistAlbums(medias: mediaDetailVM.mediaCollection[.albumsFromArtist]!)
          }

          // TODO: Load the correct data
          ArtistMediaHorizontalScrollView(medias: mediaDetailVM.mediaCollection[.playlistsFromArtist]!,
                                          sectionTitle: "Featuring \(mediaDetailVM.mainItem!.title)")
            .padding(.trailing, -25)
        }
      } else {
        ProgressView()
          .withSpotifyStyle(useDiscreetColors: true)
          .onAppear {
            mediaDetailVM.getAlbumsFromArtist()
            mediaDetailVM.getTopTracksFromArtist()
            mediaDetailVM.getPlaylistFromArtist()
          }
        Spacer()
      }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(25)
  }

  func didEverySectionLoaded() -> Bool {
    for key in mediaDetailVM.isLoading.keys {
      // If any section still loading, return false
      guard mediaDetailVM.isLoading[key] != true else {
        return false
      }
    }
    // else, return true
    return true
  }

}



struct ArtistDetailScreen_Previews: PreviewProvider {
  static var mainVM = MainViewModel()

  static var previews: some View {
    ZStack {
      ArtistDetailScreen()
      VStack {
        Spacer()
        BottomBar(mainVM: mainVM,
                  showMediaPlayer: true)
      }
    }
  }
}
