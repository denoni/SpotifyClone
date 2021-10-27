//
//  FollowButton.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/17/21.
//

import SwiftUI

struct FollowButton: View {
  @StateObject var mediaDetailVM: MediaDetailViewModel
  var itemID: String
  var itemType: APIFetchingUserInfo.ValidMediaType

  private var followingState: MediaDetailViewModel.CurrentFollowingState {
    Utility.checkIfIsFollowingItem(itemID, mediaDetailVM: mediaDetailVM)
  }

  var body: some View {
    Button(action: { MediaDetailAPICalls.UserInfoAPICalls.changeFollowingState(to: followingState == .isFollowing ? .unfollow : .follow,
                                                                               in: itemType, mediaDetailVM: mediaDetailVM,
                                                                               itemID: itemID) },
           label: {
      RoundedRectangle(cornerRadius: Constants.radiusSmall)
        .strokeBorder(Color.white.opacity(Constants.opacityStandard), lineWidth: 1)
        .foregroundColor(.clear)
        .overlay(
          VStack {
            if mediaDetailVM.followedIDs[itemID] == .error {
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
        .redacted(reason: mediaDetailVM.followedIDs[itemID] == nil ? .placeholder : [])
    })
    .buttonStyle(PlainButtonStyle())
  }
}
