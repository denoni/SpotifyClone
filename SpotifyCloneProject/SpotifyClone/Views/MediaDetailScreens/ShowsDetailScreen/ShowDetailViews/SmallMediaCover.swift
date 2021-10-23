//
//  SmallMediaCover.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct SmallMediaCover: View {
  var imageURL: String

  var body: some View {
    HStack {
      RoundedRectangle(cornerRadius: Constants.radiusStandard)
        .foregroundColor(.spotifyMediumGray)
        .overlay(RemoteImage(urlString: imageURL))
        .mask(RoundedRectangle(cornerRadius: Constants.radiusStandard).frame(width: 150, height: 150))
        .frame(width: 150, height: 150)
        .shadow(color: .spotifyDarkGray.opacity(0.3), radius: 15)
    }
    .padding(.bottom, 10)
  }
}
