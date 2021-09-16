//
//  SmallSongItem.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

import SwiftUI

struct SmallSongItem: View {
  let imageURL: String
  let title: String
  var isArtist = false
  var isPodcast = false

  let coverImageWidth: CGFloat = 130
  let coverTextWidth: CGFloat = 130 * 0.85
  let smallSongItemHeight: CGFloat = 200

  @ViewBuilder
  func buildCoverShape() -> some View {
    Group {
      if isArtist { Circle() }
      else if isPodcast { RoundedRectangle(cornerRadius: 10) }
      else { Rectangle() }
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      buildCoverShape()
        .overlay(RemoteImage(url: imageURL))
        .mask(buildCoverShape())
        .aspectRatio(1/1, contentMode: .fit)
        .frame(height: coverImageWidth)
      Text(title).font(.avenir(.heavy, size: 16))
        .frame(maxWidth: coverTextWidth, alignment: .leading)
      Spacer()
    }.frame(height: smallSongItemHeight)
  }
}