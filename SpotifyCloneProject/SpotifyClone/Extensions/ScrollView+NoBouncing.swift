//
//  ScrollView+NoBouncing.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/23/21.
//

import SwiftUI

extension ScrollView {
  func disabledBouncing() -> some View {
    self
      .modifier(BounceDisabled())
  }
}

struct BounceDisabled: ViewModifier {

    init() {
      UIScrollView.appearance().bounces = false
    }

  func body(content: Content) -> some View {
    return content
  }
}
