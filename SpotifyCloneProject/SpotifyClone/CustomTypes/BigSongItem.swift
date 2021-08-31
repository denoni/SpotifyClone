//
//  BigSongItem.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

import SwiftUI

struct BigSongItem: View {
  let coverImage: Image
  let title: String
  var artist: String = ""
  var isArtistProfile = false
  var isPodcast = false

  let coverImageWidth: CGFloat = 160
  let coverTextWidth: CGFloat = 160 * 0.85
  let smallSongItemHeigth: CGFloat = 230

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
      Text(artist).font(.avenir(.medium, size: 14))
        .frame(maxWidth: coverTextWidth, alignment: .leading)
        .opacity(0.7)
      Spacer()
    }.frame(height: smallSongItemHeigth)
  }
}
