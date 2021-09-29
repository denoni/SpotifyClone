//
//  FollowAndThreeDotsIcons.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

// TODO: Make the buttons work

struct FollowAndThreeDotsIcons: View {
  var threeDotsPlacedVertically = false
  var body: some View {
    HStack(spacing: 30) {
      RoundedRectangle(cornerRadius: 5)
        .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
        .foregroundColor(.clear)
        .overlay(
          VStack {
            Text("FOLLOW")
              .font(.avenir(.medium, size: 14))
              .padding(5)
          }
        )
        .frame(height: 35)
        .aspectRatio(3.5 / 1, contentMode: .fit)
      Image("three-dots")
        .resizable()
        .scaledToFit()
        .rotationEffect(threeDotsPlacedVertically ? Angle.degrees(90) : .zero)
      Spacer()
    }
    .frame(height: 25)
    .frame(maxWidth: .infinity)
  }
}
