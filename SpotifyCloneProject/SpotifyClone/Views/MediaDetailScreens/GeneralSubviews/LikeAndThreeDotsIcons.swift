//
//  LikeAndThreeDotsIcons.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct LikeAndThreeDotsIcons: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var body: some View {
    HStack(spacing: 30) {
      Rectangle()
        .fill(Color.clear)
        .frame(width: 25)
        .overlay( Group {
          if mediaDetailVM.userFollowsCurrentMainItem == nil {
            ProgressView()
              .withSpotifyStyle(useDiscreetColors: true)
              .scaleEffect(0.6)
          } else {
            Image(mediaDetailVM.userFollowsCurrentMainItem! ?  "heart-filled" : "heart-stroked")
              .resizable()
          }
        }.scaledToFit())

      Image("three-dots")
        .resizable()
        .scaledToFit()
      Spacer()
    }
    .frame(height: 25)
    .frame(maxWidth: .infinity)
  }
}
