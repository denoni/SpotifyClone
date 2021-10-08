//
//  SmallSongCard.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

import SwiftUI

struct SmallSongCard: View {
  let imageURL: String
  let title: String

  let grayLighter = Color(red: 0.196, green: 0.196, blue: 0.196)
  let grayDarker = Color(red: 0.153, green: 0.153, blue: 0.153)
  let grayHeavyDark = Color(red: 0.106, green: 0.106, blue: 0.106)

  var body: some View {
    ZStack(alignment: .leading) {
      RoundedRectangle(cornerRadius: Constants.radiusSmall)
        .fill(LinearGradient(gradient: Gradient(colors: [grayLighter, grayDarker]), startPoint: .top, endPoint: .bottom))
      HStack {
        Rectangle()
          .overlay(RemoteImage(urlString: imageURL))
          .foregroundColor(grayHeavyDark)
          .cornerRadius(Constants.radiusSmall, corners: [.topLeft, .bottomLeft])
          .aspectRatio(1/1, contentMode: .fit)
        Text(title)
          .font(.avenir(.heavy, size: Constants.fontSmall))
          .frame(maxWidth: .infinity, alignment: .topLeading)
          .padding(.trailing, Constants.paddingSmall)
      }
    }.aspectRatio(3/1, contentMode: .fit)
  }
}
