//
//  MyLibraryItemTypes.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import SwiftUI

struct MyLibraryDefaultMediaItem: View {
  let title: String
  let subTitle: String
  let imageURL: String
  var pinnedItem: Bool = false

  var body: some View {
    HStack(spacing: Constants.spacingSmall) {
      Rectangle()
        .foregroundColor(.spotifyMediumGray)
        .overlay(RemoteImage(urlString: imageURL).aspectRatio(1/1, contentMode: .fill))
        .frame(width: 80, height: 80)
        .mask(Rectangle().frame(width: 80, height: 80))
      VStack(alignment: .leading, spacing: 5) {
        Text(title)
          .font(.avenir(.heavy, size: Constants.fontSmall))
          .lineLimit(1)
          .padding(.trailing, Constants.paddingLarge)
        HStack(spacing: 0) {
          if pinnedItem {
            Image(systemName: "pin.fill")
              .resizeToFit()
              .frame(height: 12)
              .foregroundColor(.spotifyGreen)
              .padding(.trailing, 3)
          }
          Text(subTitle)
            .font(.avenir(.medium, size: Constants.fontXSmall))
            .opacity(Constants.opacityHigh)
            .lineLimit(1)
        }
      }
      Spacer()
    }
  }
}

struct MyLibraryArtistMediaItem: View {
  let name: String
  let imageURL: String

  var body: some View {
    HStack(spacing: Constants.spacingSmall) {
      Circle()
        .foregroundColor(.spotifyMediumGray)
        .overlay(RemoteImage(urlString: imageURL).aspectRatio(1/1, contentMode: .fill))
        .frame(width: 80, height: 80)
        .mask(Circle())
      VStack(alignment: .leading, spacing: 5) {
        Text(name)
          .font(.avenir(.heavy, size: Constants.fontSmall))
          .lineLimit(1)
          .padding(.trailing, Constants.paddingLarge)
        Text("Artist")
          .font(.avenir(.medium, size: Constants.fontXSmall))
          .opacity(Constants.opacityHigh)
      }
      Spacer()
    }
  }
}

struct MyLibraryShowMediaItem: View {
  let title: String
  let authorName: String
  let imageURL: String

  var body: some View {
    HStack(spacing: Constants.spacingSmall) {
      RoundedRectangle(cornerRadius: Constants.radiusStandard)
        .foregroundColor(.spotifyMediumGray)
        .overlay(RemoteImage(urlString: imageURL).aspectRatio(1/1, contentMode: .fill))
        .frame(width: 80, height: 80)
        .mask(RoundedRectangle(cornerRadius: Constants.radiusStandard))
      VStack(alignment: .leading, spacing: 5) {
        Text(title)
          .font(.avenir(.heavy, size: Constants.fontSmall))
          .lineLimit(1)
          .padding(.trailing, Constants.paddingLarge)
        Text("Podcast • \(authorName)")
          .font(.avenir(.medium, size: Constants.fontXSmall))
          .opacity(Constants.opacityHigh)
      }
      Spacer()
    }
  }
}
