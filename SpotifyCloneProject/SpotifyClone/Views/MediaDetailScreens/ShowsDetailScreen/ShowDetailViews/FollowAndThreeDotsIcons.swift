//
//  FollowAndThreeDotsIcons.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

// TODO: Make the buttons work

struct FollowAndThreeDotsIcons: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  var threeDotsPlacedVertically = false

  var isUserFollowing: Bool {
    guard mediaDetailVM.userFollowsCurrentMainItem != nil else { return false }
    return mediaDetailVM.userFollowsCurrentMainItem!
  }

  var body: some View {
    HStack(spacing: 30) {
      RoundedRectangle(cornerRadius: Constants.radiusSmall)
        .strokeBorder(Color.white.opacity(Constants.opacityStandard), lineWidth: 1)
        .foregroundColor(.clear)
        .overlay(
          VStack {
            Text(isUserFollowing ? "FOLLOWING" : "FOLLOW")
              .font(.avenir(.medium, size: Constants.fontXSmall))
              .padding(5)
          }
        )
        .frame(height: 35)
        .aspectRatio(isUserFollowing ? 4.5 : 3.5 / 1, contentMode: .fit)
        .redacted(reason: mediaDetailVM.userFollowsCurrentMainItem == nil ? .placeholder : [])

      Image("three-dots")
        .resizable()
        .scaledToFit()
        .rotationEffect(threeDotsPlacedVertically ? Angle.degrees(90) : .zero)
      Spacer()
    }
    .frame(height: 25)
    .frame(maxWidth: .infinity)
  }
}
