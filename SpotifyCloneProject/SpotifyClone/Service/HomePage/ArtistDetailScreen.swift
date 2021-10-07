//
//  ArtistDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistDetailScreen: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State var scrollViewPosition = CGFloat.zero

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ReadableScrollView(currentPosition: $scrollViewPosition) {
          VStack {
            ArtistPictureGradient(imageURL: mediaDetailVM.mainItem!.imageURL,
                                  height: geometry.size.height / 1.8)
            ArtistDetailContent()
              .padding(.top, -geometry.size.height / 5)
              .padding(.bottom, 180)
            Spacer()
          }
          .frame(maxHeight: .infinity, alignment: .top)
        }
        TopBarWithTitle(scrollViewPosition: $scrollViewPosition,
                        title: mediaDetailVM.mainItem!.title,
                        backButtonWithCircleBackground: true)

      }.ignoresSafeArea()
    }

  }
}



// MARK: - Detail Content

struct ArtistDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var details: SpotifyModel.ArtistDetails {
    let detailsTypes = mediaDetailVM.mainItem!.getDetails()
    switch detailsTypes {
    case .artists(let artistDetails):
      return SpotifyModel.ArtistDetails(followers: artistDetails.followers,
                                           genres: artistDetails.genres,
                                           popularity: artistDetails.popularity,
                                           id: artistDetails.id)
    default:
      fatalError("Wrong type for PlaylistDetailScreen")
    }
  }

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
            ArtistTracks(medias: mediaDetailVM.mediaCollection[.artist(.topTracksFromArtist)]!)
          }

          VStack {
            Text("Popular Albums")
              .spotifyTitle()
              .padding(.trailing, 40)
            ArtistAlbums(medias: mediaDetailVM.mediaCollection[.artist(.albumsFromArtist)]!)
          }

          // TODO: Load the correct data
          ArtistMediaHorizontalScrollView(medias: mediaDetailVM.mediaCollection[.artist(.playlistsFromArtist)]!,
                                          sectionTitle: "Featuring \(mediaDetailVM.mainItem!.title)")
            .padding(.trailing, -25)
        }
      } else {
        ProgressView()
          .withSpotifyStyle(useDiscreetColors: true)
          .onAppear {
            mediaDetailVM.getArtistScreenData()
          }
        Spacer()
      }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(25)
  }

  private func didEverySectionLoaded() -> Bool {
    for section in MediaDetailViewModel.ArtistSections.allCases {
      // If any section still loading, return false
      guard mediaDetailVM.isLoading[.artist(section)] != true else {
        return false
      }
    }
    // else, return true
    return true
  }

}



// MARK: - Preview

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
