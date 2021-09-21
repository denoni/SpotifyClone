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

  var body: some View {
    HStack(spacing: 25) {
      ColorfulCard(text: titles[0],
                   imageURL: imagesURL[0],
                   color: Color(#colorLiteral(red: 0.7710836391, green: 0.1485622513, blue: 0.5117851418, alpha: 1)))
      ColorfulCard(text: titles[1],
                   imageURL: imagesURL[1],
                   color: Color(#colorLiteral(red: 0.6385955811, green: 0.3077141699, blue: 0.1555032398, alpha: 1)))
    }
    .frame(height: 100)
  }
}
