//
//  ColorfulCard.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct ColorfulCard: View {
  var text: String
  var image: Image
  var color: Color

  var isPodcast = false

  var getCornerRadius: CGFloat {
    isPodcast ? 10 : 0
  }

  @ViewBuilder
  var body: some View {
    ZStack() {
      RoundedRectangle(cornerRadius: 5)
        .fill(color)
      Text(text)
        .foregroundColor(.white)
        .font(.avenir(.black, size: 18))
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .padding(.trailing, 45)
        .padding(.bottom, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      RoundedRectangle(cornerRadius: getCornerRadius)
        .frame(width: 80, height: 80)
        .overlay(image.resizeToFit().mask(RoundedRectangle(cornerRadius: getCornerRadius)))
        .rotationEffect(Angle(degrees: 25))
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding(.vertical, -5)
        .padding(.horizontal, -20)
        .mask(RoundedRectangle(cornerRadius: 5))
    }
  }
}
