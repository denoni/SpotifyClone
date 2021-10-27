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

  private var textHasMoreThanOneWord: Bool {
    if text.contains(" ") {
      return true
    } else {
      return false
    }
  }

  private var getCornerRadius: CGFloat {
    isPodcast ? Constants.radiusStandard : 0
  }

  @ViewBuilder var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .fill(color)
      Text(text)
        .foregroundColor(.white)
        .font(.avenir(.black, size: Constants.fontSmall))
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .padding(.trailing, Constants.paddingLarge)
        .padding(.bottom, Constants.paddingStandard)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .lineLimit(textHasMoreThanOneWord ? 2 : 1)
      RoundedRectangle(cornerRadius: getCornerRadius)
        .foregroundColor(Color.spotifyMediumGray)
        .frame(width: 80, height: 80)
        .overlay(RemoteImage(urlString: imageURL).mask(RoundedRectangle(cornerRadius: getCornerRadius)))
        .rotationEffect(Angle(degrees: 25))
        .shadow(radius: Constants.radiusStandard)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding(.vertical, -5)
        .padding(.horizontal, -20)
        .mask(RoundedRectangle(cornerRadius: 5))
    }
  }
}
