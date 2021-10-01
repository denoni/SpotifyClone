//
//  PlaylistsScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct PlaylistsScrollView: View {
  @State var medias: [SpotifyModel.MediaItem]

  var body: some View {
    LazyVStack {
      ForEach(medias) { media in
        HStack(spacing: 12) {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(RemoteImage(urlString: media.imageURL))
            .frame(width: 60, height: 60)
          VStack(alignment: .leading) {
            Text(media.title)
              .font(.avenir(.medium, size: 20))
            Text(media.authorName.joined(separator: ", "))
              .font(.avenir(.medium, size: 16))
              .opacity(0.7)
          }
          Spacer()
          Image("three-dots")
            .resizeToFit()
            .padding(.vertical, 16)
        }
        .frame(height: 60)
      }
    }
    .padding(.top, 15)
  }
}
