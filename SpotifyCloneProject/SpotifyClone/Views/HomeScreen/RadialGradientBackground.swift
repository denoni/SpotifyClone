//
//  RadialGradientBackground.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

// TODO: Make gradient color represent the color of the first song cover in HomeScreen
struct RadialGradientBackground: View {
  let backgroundGradientColor = Color(red: 0.051, green: 0.608, blue: 0.784)

  var body: some View {
    RadialGradient(gradient: Gradient(colors: [backgroundGradientColor.opacity(0.35), backgroundGradientColor.opacity(0.0)]),
                   center: .topLeading,
                   startRadius: 10,
                   endRadius: 600)
      .ignoresSafeArea()
  }
}
