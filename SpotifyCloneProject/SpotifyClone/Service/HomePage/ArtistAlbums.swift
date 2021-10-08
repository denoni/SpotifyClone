//
//  ArtistAlbums.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistAlbums: View {
  let medias: [SpotifyModel.MediaItem]

  var body: some View {
    VStack {
      ForEach(medias) { media in
        HStack(spacing: Constants.spacingSmall) {
          VStack(alignment: .leading) {
            Text(media.title)
              .font(.avenir(.medium, size: Constants.fontSmall))
              .lineLimit(1)
              .padding(.trailing, Constants.paddingLarge)
            Text("Album • 2020") // TODO: Add real data
              .font(.avenir(.medium, size: Constants.fontXSmall))
              .lineLimit(1)
              .opacity(Constants.opacityHigh)
          }
          Spacer()
        }
        .padding(.top, 5)
      }
      SeeMoreButton()
        .padding(.top, 10)
        .opacity(Constants.opacityHigh)
    }
  }
}
