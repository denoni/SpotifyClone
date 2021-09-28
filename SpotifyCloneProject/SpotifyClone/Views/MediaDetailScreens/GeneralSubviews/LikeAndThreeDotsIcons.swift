//
//  LikeAndThreeDotsIcons.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct LikeAndThreeDotsIcons: View {
  var body: some View {
    HStack(spacing: 30) {
      Image("heart-stroked")
        .resizable()
        .scaledToFit()
      Image("three-dots")
        .resizable()
        .scaledToFit()
      Spacer()
    }
    .frame(height: 25)
    .frame(maxWidth: .infinity)
  }
}
