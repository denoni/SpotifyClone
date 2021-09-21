//
//  Color+Random.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/21/21.
//

import SwiftUI

extension Color {
  static var random: Color {
    return Color(
      // Not using 0...1 to reduce extremely bright/dark colors
      red: .random(in: 0.2...0.95),
      green: .random(in: 0.2...0.95),
      blue: .random(in: 0.2...0.95)
    )
  }
}
