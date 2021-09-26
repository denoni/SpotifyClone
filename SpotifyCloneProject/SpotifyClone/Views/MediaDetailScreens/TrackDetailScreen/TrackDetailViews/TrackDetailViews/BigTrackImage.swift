//
//  BigTrackImage.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct BigTrackImage: View {
  var imageURL: String

  var body: some View {
    Rectangle()
      .fill(Color.white)
      .aspectRatio(1/1, contentMode: .fill)
      .overlay(RemoteImage(urlString: imageURL))
      .padding(.bottom, 25)
      .shadow(color: .spotifyDarkerGray.opacity(0.3), radius: 15)
  }
}
