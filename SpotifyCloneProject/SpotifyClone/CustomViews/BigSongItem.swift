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

  @ViewBuilder
  func buildCoverShape() -> some View {
    Group {
      if mediaType == .artist { Circle() }
      else if mediaType == .show { RoundedRectangle(cornerRadius: 10) }
      else { Rectangle() }
    }.foregroundColor(Color.spotifyDarkGray)
  }

  var body: some View {
    VStack(alignment: .leading) {
      buildCoverShape()
        .overlay(RemoteImage(urlString: imageURL))
        .mask(buildCoverShape())
        .aspectRatio(1/1, contentMode: .fit)
        .frame(height: coverImageWidth)
      Text(title).font(.avenir(.heavy, size: 16))
        .frame(maxWidth: coverTextWidth, alignment: .leading)
      Text(artist).font(.avenir(.medium, size: 14))
        .frame(maxWidth: coverTextWidth, alignment: .leading)
        .opacity(0.7)
      Spacer()
    }.frame(height: smallSongItemHeight)
  }
}
