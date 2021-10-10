//
//  SearchResponseItem.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/10/21.
//

import SwiftUI

struct SearchResponseItem: View {
  let imageURL: String
  let title: String
  let author: String
  let mediaType: SpotifyModel.MediaTypes

  var subTitle: String {
    switch mediaType {
    case .album:
      return "Album • \(author)"
    case .track:
      return "Song • \(author)"
    case .playlist:
      return "Playlist"
    case .show:
      return "Show • \(author)"
    case .artist:
      return "Artist"
    case .episode:
      return "Episode"
    }
  }

  var body: some View {

    HStack {
      ZStack(alignment: .center) {
        Rectangle()
          .foregroundColor(.spotifyMediumGray)
          .overlay(RemoteImage(urlString: imageURL).aspectRatio(1/1, contentMode: .fill))
          .mask(
            Group {
              switch mediaType {
              case .track, .album, .playlist:
                Rectangle()
              case .show, .episode:
                RoundedRectangle(cornerRadius: Constants.radiusStandard)
              case .artist:
                Circle()
              }
            })
      }
      .frame(width: 60, height: 60)
      VStack(alignment: .leading) {
        Text(title)
          .font(.avenir(.medium, size: Constants.fontMedium))
        Text(subTitle)
          .font(.avenir(.medium, size: Constants.fontSmall))
          .opacity(Constants.opacityStandard)
      }
      .padding(.leading, Constants.paddingSmall)
      Spacer()
      Image("three-dots")
        .resizeToFit()
        .padding(.vertical, Constants.fontSmall)
    }
    .frame(height: 60)
    .padding(.horizontal, Constants.paddingStandard)

  }

}
