//
//  BigMediaCover.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct BigMediaCover: View {
  var imageURL: String

  var body: some View {
    HStack {
      Spacer()
      Rectangle()
        .foregroundColor(.spotifyMediumGray)
        .overlay(RemoteImage(urlString: imageURL))
        .mask(Rectangle().frame(width: 250, height: 250))
        .frame(width: 250, height: 250)
        .shadow(color: .spotifyDarkGray.opacity(Constants.opacityXHigh), radius: Constants.radiusStandard)
      Spacer()
    }
    .padding(.bottom, 10)
  }
}
