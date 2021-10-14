//
//  FollowAndThreeDotsIcons.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct FollowAndThreeDotsIcons: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  var threeDotsPlacedVertically = false

  var body: some View {
    HStack(spacing: 30) {
      Button(action: { MediaDetailViewModel.UserInfoAPICalls.follow(.artist, mediaVM: mediaDetailVM) }) {
        RoundedRectangle(cornerRadius: Constants.radiusSmall)
          .strokeBorder(Color.white.opacity(Constants.opacityStandard), lineWidth: 1)
          .foregroundColor(.clear)
          .overlay(
            VStack {
              if mediaDetailVM.errorOccurredWhileTryingToFollow == true {
                Text("ERROR")
                  .font(.avenir(.medium, size: Constants.fontXSmall))
                  .padding(5)
              } else {
                Text(mediaDetailVM.userFollowsCurrentMainItem ?? false ? "FOLLOWING" : "FOLLOW")
                  .font(.avenir(.medium, size: Constants.fontXSmall))
                  .padding(5)
              }
            }
          )
          .frame(height: 35)
          .aspectRatio(mediaDetailVM.userFollowsCurrentMainItem ?? false ? 4.5 : 3.5 / 1, contentMode: .fit)
          .redacted(reason: mediaDetailVM.userFollowsCurrentMainItem == nil ? .placeholder : [])
      }
      .buttonStyle(PlainButtonStyle())

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
