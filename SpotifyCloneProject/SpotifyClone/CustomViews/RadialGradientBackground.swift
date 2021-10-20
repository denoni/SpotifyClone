//
//  RadialGradientBackground.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct RadialGradientBackground: View {
  var color: Color = Color(red: 0.051, green: 0.608, blue: 0.784)

  var body: some View {
    RadialGradient(gradient: Gradient(colors: [color.opacity(0.35), color.opacity(0.0)]),
                   center: .topLeading,
                   startRadius: 10,
                   endRadius: 600)
      .ignoresSafeArea()
  }
}
