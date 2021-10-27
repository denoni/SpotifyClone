//
//  BigSongItem.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

import SwiftUI

struct BigSongItem: View {
  let imageURL: String
  let title: String
  var artist: String = ""
  var mediaType: SpotifyModel.MediaTypes

  let coverImageWidth: CGFloat = 160
  let coverTextWidth: CGFloat = 160 * 0.85
  let smallSongItemHeight: CGFloat = 230

  @ViewBuilder func buildCoverShape() -> some View {
    Group {
      if mediaType == .artist {
        Circle()
      } else if mediaType == .show {
        RoundedRectangle(cornerRadius: Constants.radiusStandard)
      } else {
        Rectangle()
      }
    }.foregroundColor(Color.spotifyDarkGray)
  }

  var body: some View {
    VStack(alignment: .leading) {
      buildCoverShape()
        .overlay(RemoteImage(urlString: imageURL))
        .mask(buildCoverShape())
        .aspectRatio(1/1, contentMode: .fit)
        .frame(height: coverImageWidth)
      Text(title).font(.avenir(.heavy, size: Constants.fontSmall))
        .frame(maxWidth: coverTextWidth, alignment: .leading)
        .lineLimit(2)
      Text(artist).font(.avenir(.medium, size: Constants.fontXSmall))
        .frame(maxWidth: coverTextWidth, alignment: .leading)
        .opacity(Constants.opacityStandard)
        .lineLimit(1)
      Spacer()
    }.frame(height: smallSongItemHeight)
  }
}
