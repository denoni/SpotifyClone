//
//  SeeMoreButton.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct SeeMoreButton: View {
  var body: some View {
    Capsule()
      .strokeBorder(Color.white, lineWidth: 0.5)
      .foregroundColor(.clear)
      .overlay(Text("See more")
                .font(.avenir(.medium, size: Constants.fontSmall))
                .padding(3))
      .frame(width: 120, height: 30, alignment: .center)
  }
}
