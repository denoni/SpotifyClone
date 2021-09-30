//
//  ArtistTracks.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistTracks: View {
  @State var medias: [SpotifyModel.MediaItem]

  var body: some View {
    VStack {
      ForEach(medias) { media in
        HStack(spacing: 12) {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(RemoteImage(urlString: media.imageURL))
            .frame(width: 80, height: 80)
          VStack(alignment: .leading) {
            Text(media.title)
              .font(.avenir(.medium, size: 18))
              .lineLimit(1)
            Text("Single • 2020") // TODO: Show real data
              .font(.avenir(.medium, size: 14))
              .opacity(0.7)
              .lineLimit(1)
          }
          Spacer()
        }
        .frame(height: 100)
        .padding(.top, 5)
        
      }
      SeeMoreButton()
        .padding(.top, 5)
        .opacity(0.7)
    }
  }
}



