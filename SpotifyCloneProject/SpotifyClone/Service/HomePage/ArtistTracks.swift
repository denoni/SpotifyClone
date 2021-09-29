//
//  ArtistTracks.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistTracks: View {
  let arr = [1,2,3,4,5]

  var body: some View {
    VStack {
      ForEach(arr, id: \.self) { _ in
        HStack(spacing: 12) {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(Image("come-as-you-are-cover")
                      .resizeToFit())
            .frame(width: 80, height: 80)
          VStack(alignment: .leading) {
            Text("Thank u next")
              .font(.avenir(.medium, size: 18))
              .lineLimit(1)
            Text("Single • 2020")
              .font(.avenir(.medium, size: 14))
              .opacity(0.7)
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



