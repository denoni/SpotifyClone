//
//  Text+SpotifySizes.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/1/21.
//

import SwiftUI

extension Text {

  @ViewBuilder func spotifyTitle(withPadding: Bool = false) -> some View {
    self
      .font(.avenir(.heavy, size: Constants.fontLarge))
      .frame(maxWidth: .infinity, alignment: .topLeading)
      .padding(.leading, withPadding ? Constants.paddingStandard : 0)
  }
}
