//
//  BigTrackImage.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct BigTrackImage: View {
  var imageURL: String
  var isSmallDisplay: Bool = false

  var body: some View {
    Rectangle()
      .fill(Color.white)
      .aspectRatio(1/1, contentMode: .fill)
      .overlay(RemoteImage(urlString: imageURL)
                .mask(Rectangle().aspectRatio(1/1, contentMode: .fit)))
      .shadow(color: .spotifyDarkGray.opacity(Constants.opacityXHigh), radius: 15)
      .padding(.horizontal, isSmallDisplay ? Constants.paddingStandard : 0)
  }
}
