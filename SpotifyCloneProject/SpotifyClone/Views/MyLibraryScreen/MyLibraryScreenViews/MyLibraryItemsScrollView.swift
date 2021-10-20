//
//  MyLibraryItemsScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import SwiftUI

struct MyLibraryItemsScrollView: View {
  @State var medias: [SpotifyModel.MediaItem]

  init(medias: [SpotifyModel.MediaItem]) {
    var mediasWithPinnedItems: [SpotifyModel.MediaItem]
    mediasWithPinnedItems = [FixedSectionsItems.likedSongs, FixedSectionsItems.yourEpisodes]
    mediasWithPinnedItems += medias
    self.medias = mediasWithPinnedItems
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack {
        ForEach(medias) { media in
          HStack(spacing: Constants.spacingSmall) {
            Rectangle()
              .foregroundColor(.spotifyMediumGray)
              .overlay(RemoteImage(urlString: media.imageURL).scaledToFit().aspectRatio(1/1, contentMode: .fit))
              .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 5) {
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
    .padding(.horizontal, Constants.paddingStandard)
  }

  // Those are items that should be fixed on top of the scroll view and cannot be fetched from API.
  fileprivate struct FixedSectionsItems {
    static let likedSongs = SpotifyModel.MediaItem(title: "Liked Songs", previewURL: "Playlist • 33 songs", imageURL: "https://i.ibb.co/w4jgnbs/liked-songs-300.png", authorName: ["Spotify"], author: nil, mediaType: .playlist, id: "liked-songs", details: SpotifyModel.DetailTypes.playlists(playlistDetails:SpotifyModel.PlaylistDetails(description: "Saved and downloaded episodes", playlistTracks: SpotifyModel.PlaylistTracks(numberOfSongs: 0, href: ""), owner: SpotifyModel.MediaOwner(displayName: "", id: "0"), id: "")))

    static let yourEpisodes = SpotifyModel.MediaItem(title: "Your Episodes", previewURL: "Saved & downloaded episodes", imageURL: "https://i.ibb.co/bbZH8pS/Screen-Shot-2021-10-20-at-12-37-06-AM.png", authorName: ["Spotify"], author: nil, mediaType: .playlist, id: "your-episodes", details: SpotifyModel.DetailTypes.playlists(playlistDetails:SpotifyModel.PlaylistDetails(description: "", playlistTracks: SpotifyModel.PlaylistTracks(numberOfSongs: 0, href: ""), owner: SpotifyModel.MediaOwner(displayName: "", id: "1"), id: "")))
  }

}
