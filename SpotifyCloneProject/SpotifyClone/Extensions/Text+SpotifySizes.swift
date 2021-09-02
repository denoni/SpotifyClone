//
//  Text+SpotifySizes.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/1/21.
//

import SwiftUI

extension Text {

  @ViewBuilder
  func spotifyTitle(withPadding: Bool = false) -> some View {
    self
      .font(.avenir(.heavy, size: titleFontSize))
      .frame(maxWidth: .infinity, alignment: .topLeading)
      .padding(.leading, withPadding ? lateralPadding : 0)
  }
}
