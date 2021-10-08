//
//  ColorfulCardPair.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/21/21.
//

import SwiftUI

struct ColorfulCardPair: View {
  var titles: [String]
  var imagesURL: [String]
  var colors: [Color]

  var body: some View {
    HStack(spacing: Constants.paddingStandard) {
      ColorfulCard(text: titles[0],
                   imageURL: imagesURL[0],
                   color: colors[0])
      ColorfulCard(text: titles[1],
                   imageURL: imagesURL[1],
                   color: colors[1])
    }
    .frame(height: 100)
  }
}
