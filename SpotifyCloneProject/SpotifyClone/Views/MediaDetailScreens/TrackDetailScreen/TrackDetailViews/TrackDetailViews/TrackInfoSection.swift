//
//  TrackInfoSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct TrackInfoSection: View {
  var songName: String
  var artistName: String
  var isLiked: Bool
  var isExplicit: Bool

  var body: some View {
    Group {
      HStack {
        VStack(alignment: .leading,
               spacing: 0) {
          Text(songName)
            .font(.avenir(.black, size: 26))
            .foregroundColor(.white)
          HStack(spacing: 0) {
            ExplicitIcon(isExplicit: isExplicit)
              .padding(.trailing, isExplicit ? 5 : 0)
            Text(artistName)
              .font(.avenir(.medium, size: 18))
              .foregroundColor(.white)
              .tracking(0.5)
          }
          .opacity(0.7)
        }.frame(
          maxWidth: .infinity,
          alignment: .topLeading
        )
        Image(isLiked ? "heart-filled" : "heart-stroked")
          .resizeToFit()
          .padding(3)
          .frame(height: 30)
      }
    }.frame(height: 60)
  }
}
