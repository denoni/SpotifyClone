//
//  BigMediaCover.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct BigMediaCover: View {
  @State var imageURL: String

  var body: some View {
    HStack {
      Spacer()
      Rectangle()
        .foregroundColor(.spotifyMediumGray)
        .overlay(RemoteImage(urlString: imageURL))
        .frame(width: 250, height: 250)
        .shadow(color: .spotifyDarkerGray.opacity(0.3), radius: 15)
      Spacer()
    }
    .padding(.bottom, 10)
  }
}
