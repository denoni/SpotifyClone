//
//  TopSafeAreaSize.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/7/21.
//

import SwiftUI

private struct TopSafeAreaSize: EnvironmentKey {
  static let defaultValue = 0
}

extension EnvironmentValues {
  var topSafeAreaSize: CGFloat {

    get {
      let window = UIApplication.shared.windows[0]
      let safeFrame = window.safeAreaLayoutGuide.layoutFrame
      return safeFrame.minY
    }

  }
}
