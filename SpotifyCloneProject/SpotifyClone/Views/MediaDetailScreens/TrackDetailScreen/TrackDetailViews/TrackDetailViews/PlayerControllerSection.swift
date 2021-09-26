//
//  PlayerControllerSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct PlayerControllerSection: View {
  var body: some View {
    HStack() {
      Image("play-mix")
        .resizeToFit()
        .padding(.vertical, 24)
      Spacer()
      Image("previous")
        .resizeToFit()
        .padding(.vertical, 22)
      Spacer()
      Image("circle-play")
        .resizeToFit()
      Spacer()
      Image("next")
        .resizeToFit()
        .padding(.vertical, 22)
      Spacer()
      Image("play-repeat")
        .resizeToFit()
        .padding(.vertical, 24)
    }
    .frame(height: 70,
           alignment: .center)
  }
}
