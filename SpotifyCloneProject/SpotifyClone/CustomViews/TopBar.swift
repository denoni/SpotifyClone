//
//  TopBar.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/3/21.
//

import SwiftUI

struct TopBar: View {
  @Environment(\.topSafeAreaSize) var topSafeAreaSize
  var animateOpacityWith: CGFloat
  var body: some View {
    Group {
      let opacity = Double(animateOpacityWith / UIScreen.main.bounds.height * 2)

      VStack {
        Rectangle()
          .foregroundColor(.black)
          .frame(height: topSafeAreaSize)
          .frame(maxWidth: .infinity)
          .opacity(opacity > Constants.opacityLow ? Constants.opacityLow : opacity)
          .ignoresSafeArea()
        Spacer()
      }
    }
  }
}
