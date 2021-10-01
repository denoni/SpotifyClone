//
//  PlaylistsScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct PlaylistsScrollView: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State var medias: [SpotifyModel.MediaItem]

  var body: some View {
    LazyVStack {
      ForEach(medias) { media in
        PlaylistItem(imageURL: media.imageURL,
                     title: media.title,
                     authorName: media.authorName.joined(separator: ", "))
        .frame(height: 60)
        .onAppear { testIfShouldFetchMoreData(basedOn: media) }
      }
    }
    .padding(.top, 15)
  }

  func testIfShouldFetchMoreData(basedOn media: SpotifyModel.MediaItem) {
    if medias.count > 5 {
      if media.id == medias[medias.count - 4].id {
        MediaDetailViewModel.PlaylistAPICalls.getTracksFromPlaylist(mediaVM: mediaDetailVM, loadMoreEnabled: true)
      }
    }
  }

}

struct PlaylistItem: View {
  let imageURL: String
  let title: String
  let authorName: String

  var body: some View {
    HStack(spacing: 12) {
      Rectangle()
        .foregroundColor(.spotifyMediumGray)
        .overlay(RemoteImage(urlString: imageURL))
        .frame(width: 60, height: 60)
      VStack(alignment: .leading) {
        Text(title)
          .font(.avenir(.medium, size: 20))
        Text(authorName)
          .font(.avenir(.medium, size: 16))
          .opacity(0.7)
      }
      Spacer()
      Image("three-dots")
        .resizeToFit()
        .padding(.vertical, 16)
    }
  }
}
