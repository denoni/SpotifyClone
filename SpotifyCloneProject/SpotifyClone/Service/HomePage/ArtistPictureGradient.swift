//
//  ArtistPictureGradient.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistPictureGradient: View {
  var imageURL: String
  var height: CGFloat

  var body: some View {
    VStack {
      Rectangle()
        .overlay(
          ZStack {
            RemoteImage(urlString: imageURL)
              .scaledToFill()
            LinearGradient(gradient: Gradient(colors: [.clear,
                                                       .spotifyDarkGray.opacity(Constants.opacityStandard),
                                                       .spotifyDarkGray]),
                           startPoint: .top,
                           endPoint: .bottom)
          }
        )
        .frame(height: height, alignment: .top)
      Spacer()
    }
  }
}
