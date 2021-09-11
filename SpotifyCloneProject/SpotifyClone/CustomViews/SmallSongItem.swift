//
//  SmallSongItem.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

import SwiftUI

struct SmallSongItem: View {
  let coverImage: Image
  let title: String
  var isArtistProfile = false
  var isPodcast = false

  let coverImageWidth: CGFloat = 130
  let coverTextWidth: CGFloat = 130 * 0.85
  let smallSongItemHeight: CGFloat = 200

  @ViewBuilder
  func buildCoverShape() -> some View {
    Group {
      if isArtistProfile { Circle() }
      else if isPodcast { RoundedRectangle(cornerRadius: 10) }
      else { Rectangle() }
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      buildCoverShape()
        .overlay(coverImage.resizable())
        .mask(buildCoverShape())
        .aspectRatio(1/1, contentMode: .fit)
        .frame(height: coverImageWidth)
      Text(title).font(.avenir(.heavy, size: 16))
        .frame(maxWidth: coverTextWidth, alignment: .leading)
      Spacer()
    }.frame(height: smallSongItemHeight)
  }
}
