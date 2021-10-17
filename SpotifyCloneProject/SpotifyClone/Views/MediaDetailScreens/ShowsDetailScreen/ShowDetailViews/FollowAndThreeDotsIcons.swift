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

  var mediaTypeThatIsUsingThisView: APIFetchingUserInfo.ValidMediaType {
    switch mediaDetailVM.mainItem!.mediaType {
    case .artist:
      return .artist
    case .show:
      return .show
    default:
      fatalError("Media type is not compatible with this struct.")
    }
  }

  var followingState: MediaDetailViewModel.CurrentFollowingState {
    guard mediaDetailVM.followedIDs[mediaDetailVM.mainItem!.id] != nil else { return .isNotFollowing }
    return mediaDetailVM.followedIDs[mediaDetailVM.mainItem!.id]!
  }

  var body: some View {
    HStack(spacing: 30) {
      Button(action: { MediaDetailViewModel.UserInfoAPICalls.changeFollowingState(to: followingState == .isFollowing ? .unfollow : .follow,
                                                                                  in: mediaTypeThatIsUsingThisView, mediaVM: mediaDetailVM,
                                                                                  itemID: mediaDetailVM.mainItem!.id) }) {
        RoundedRectangle(cornerRadius: Constants.radiusSmall)
          .strokeBorder(Color.white.opacity(Constants.opacityStandard), lineWidth: 1)
          .foregroundColor(.clear)
          .overlay(
            VStack {
              if mediaDetailVM.followedIDs[mediaDetailVM.mainItem!.id] == .error {
                Text("ERROR")
                  .font(.avenir(.medium, size: Constants.fontXSmall))
                  .padding(5)
              } else {
                Text(followingState == .isFollowing ? "FOLLOWING" : "FOLLOW")
                  .font(.avenir(.medium, size: Constants.fontXSmall))
                  .padding(5)
              }
            }
          )
          .frame(height: 35)
          .aspectRatio(followingState == .isFollowing ? 4.5 : 3.5 / 1, contentMode: .fit)
          .redacted(reason: mediaDetailVM.followedIDs[mediaDetailVM.mainItem!.id] == nil ? .placeholder : [])
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
