//
//  Image+ResizeToFit.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/1/21.
//

import SwiftUI

extension Image {

  @ViewBuilder func resizeToFit() -> some View {
    self
      .resizable()
      .scaledToFit()
  }
}
