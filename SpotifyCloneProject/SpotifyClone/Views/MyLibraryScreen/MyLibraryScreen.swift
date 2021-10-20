//
//  MyLibraryScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/19/21.
//

import SwiftUI

struct MyLibraryScreen: View {
  static let mediaForTest = SpotifyModel.MediaItem(title: "Don't Stop Me Now",
                                                   previewURL: "",
                                                   imageURL: "https://i.scdn.co/image/ab67616d0000b273008b06ec71019afd70153889",
                                                   authorName: ["Queen"],
                                                   author: nil,
                                                   mediaType: .track,
                                                   id: UUID().uuidString,
                                                   details: SpotifyModel.DetailTypes
                                                    .tracks(trackDetails: SpotifyModel.TrackDetails(popularity: 0,
                                                                                                    explicit: false,
                                                                                                    description: nil,
                                                                                                    durationInMs: 0,
                                                                                                    id: "abc",
                                                                                                    album: nil)))


  let mediaTestArray = Array(repeating: mediaForTest, count: 5)

  var body: some View {
    VStack {
      ZStack {
        ScrollView(showsIndicators: false) {
          MyLibraryItemsScrollView(medias: mediaTestArray)
        }
        .padding(.horizontal, Constants.paddingStandard)

        LibraryTopBar()
      }
    }
  }
}

fileprivate struct LibraryTopBar: View {
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  var body: some View {
    VStack {
      ZStack {
        Color.spotifyMediumGray
          .shadow(color: .black, radius: 10)
        VStack {
          Spacer()
          HStack(spacing: 10) {
            Circle()
              .fill(Color.spotifyGreen)
              .overlay(Text("G").fontWeight(.bold).foregroundColor(.black))
              .scaledToFit()
            Text("My Library")
              .font(.avenir(.black, size: Constants.fontMedium))
            Spacer()
            Image("search-unselected")
              .resizeToFit()
              .padding(8)
              .opacity(Constants.opacityLow)
            Image(systemName: "plus") // TODO: Use the real icon from Spotify
              .resizeToFit()
              .padding(8)
              .opacity(Constants.opacityLow)
          }
          .frame(height: 35)
          .frame(maxWidth: .infinity)
          .padding(.horizontal, Constants.paddingStandard)
          Spacer()
        }
        .padding(.top, topSafeAreaSize)
      }
      .frame(height: 60 + topSafeAreaSize)
      .frame(maxWidth: .infinity)
      .ignoresSafeArea()
      Spacer()
    }
    .frame(maxHeight: .infinity)
  }
}

fileprivate struct MyLibraryItemsScrollView: View {
  @State var medias: [SpotifyModel.MediaItem]

  init(medias: [SpotifyModel.MediaItem]) {
    var mediasWithPinnedItems: [SpotifyModel.MediaItem]
    mediasWithPinnedItems = [FixedSectionsItems.likedSongs, FixedSectionsItems.yourEpisodes]
    mediasWithPinnedItems += medias
    self.medias = mediasWithPinnedItems
  }

  var body: some View {
    VStack {
      ForEach(medias) { media in
        HStack(spacing: Constants.spacingSmall) {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(RemoteImage(urlString: media.imageURL))
            .frame(width: 80, height: 80)
          VStack(alignment: .leading) {
            Text(media.title)
              .font(.avenir(.heavy, size: Constants.fontSmall))
              .lineLimit(1)
              .padding(.trailing, Constants.paddingLarge)
            HStack(spacing: 0) {
              if media.id == "liked-songs" || media.id == "your-episodes" {
                Image(systemName: "pin.fill")
                  .resizeToFit()
                  .frame(height: 12)
                  .foregroundColor(.spotifyGreen)
                  .padding(.trailing, 3)
              }
              Text(media.previewURL) // TODO: Show real data
                .font(.avenir(.medium, size: Constants.fontXSmall))
                .opacity(Constants.opacityHigh)
                .lineLimit(1)
            }
          }
          Spacer()
        }
        .frame(height: 80)
        .padding(.bottom, 10)
        .onTapGesture {
          //TODO: Add on tap
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.bottom, Constants.paddingBottomSection)
    .padding(.top, 60 + Constants.paddingStandard)
  }
}



fileprivate struct FixedSectionsItems {
  static let likedSongs = SpotifyModel.MediaItem(title: "Liked Songs", previewURL: "Playlist • 33 songs", imageURL: "https://i.ibb.co/w4jgnbs/liked-songs-300.png", authorName: ["Spotify"], author: nil, mediaType: .playlist, id: "liked-songs", details: SpotifyModel.DetailTypes.playlists(playlistDetails:SpotifyModel.PlaylistDetails(description: "Saved and downloaded episodes", playlistTracks: SpotifyModel.PlaylistTracks(numberOfSongs: 0, href: ""), owner: SpotifyModel.MediaOwner(displayName: "", id: "0"), id: "")))

  static let yourEpisodes = SpotifyModel.MediaItem(title: "Your Episodes", previewURL: "Saved & downloaded episodes", imageURL: "https://i.ibb.co/bbZH8pS/Screen-Shot-2021-10-20-at-12-37-06-AM.png", authorName: ["Spotify"], author: nil, mediaType: .playlist, id: "your-episodes", details: SpotifyModel.DetailTypes.playlists(playlistDetails:SpotifyModel.PlaylistDetails(description: "", playlistTracks: SpotifyModel.PlaylistTracks(numberOfSongs: 0, href: ""), owner: SpotifyModel.MediaOwner(displayName: "", id: "1"), id: "")))
}



struct MyLibraryScreen_Previews: PreviewProvider {
  static var previews: some View {
    MyLibraryScreen()
  }
}
