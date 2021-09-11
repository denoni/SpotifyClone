//
//  SmallSongCard.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

import SwiftUI

struct SmallSongCard: View {
  let image: Image
  let title: String

  let grayLighter = Color(red: 0.196, green: 0.196, blue: 0.196)
  let grayDarker = Color(red: 0.153, green: 0.153, blue: 0.153)
  let grayHeavyDark = Color(red: 0.106, green: 0.106, blue: 0.106)

  var body: some View {
    ZStack(alignment: .leading) {
      RoundedRectangle(cornerRadius: 5)
        .fill(LinearGradient(gradient: Gradient(colors: [grayLighter, grayDarker]), startPoint: .top, endPoint: .bottom))
      HStack {
        Rectangle()
          .overlay(image.resizable())
          .foregroundColor(grayHeavyDark)
          .cornerRadius(5, corners: [.topLeft, .bottomLeft])
          .aspectRatio(1/1, contentMode: .fit)
        Text(title)
          .font(.avenir(.heavy, size: 16))
          .frame(maxWidth: .infinity, alignment: .topLeading)
      }
    }.aspectRatio(3/1, contentMode: .fit)
  }
}
