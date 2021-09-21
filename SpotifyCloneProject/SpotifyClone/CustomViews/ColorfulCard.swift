//
//  ColorfulCard.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct ColorfulCard: View {
  var text: String
  var imageURL: String
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
        .padding(.trailing, 60)
        .padding(.bottom, 25)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      RoundedRectangle(cornerRadius: getCornerRadius)
        .frame(width: 80, height: 80)
        .overlay(RemoteImage(urlString: imageURL).mask(RoundedRectangle(cornerRadius: getCornerRadius)))
        .rotationEffect(Angle(degrees: 25))
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding(.vertical, -5)
        .padding(.horizontal, -20)
        .mask(RoundedRectangle(cornerRadius: 5))
    }
  }
}
