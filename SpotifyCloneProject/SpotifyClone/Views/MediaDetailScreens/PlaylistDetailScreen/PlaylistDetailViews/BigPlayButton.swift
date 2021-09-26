//
//  BigPlayButton.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct BigPlayButton: View {
  var body: some View {
    Circle()
      .scaledToFit()
      .foregroundColor(.spotifyGreen)
      .overlay(Image("play").resizeToFit().padding(20).padding(.leading, 3))
  }
}
