//
//  HeartButton.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/17/21.
//

import SwiftUI

struct HeartButton: View {
  @StateObject var mediaDetailVM: MediaDetailViewModel
  var itemID: String
  var itemType: APIFetchingUserInfo.ValidMediaType

  private var followingState: MediaDetailViewModel.CurrentFollowingState {
    Utility.checkIfIsFollowingItem(itemID, mediaDetailVM: mediaDetailVM)
  }

  var body: some View {
    Button(action: {  MediaDetailAPICalls.UserInfoAPICalls.changeFollowingState(to: followingState == .isFollowing ? .unfollow : .follow,
                                                                                in: itemType,
                                                                                mediaDetailVM: mediaDetailVM,
                                                                                itemID: itemID) },
           label: {
      if mediaDetailVM.followedIDs[itemID] == .error {
        Image(systemName: "xmark.octagon.fill")
          .resizable()
          .aspectRatio(1/1, contentMode: .fit)
          .frame(width: 25)
      } else {
        Rectangle()
          .fill(Color.clear)
          .frame(width: 25)
          .overlay(
            Group {
              if mediaDetailVM.followedIDs[itemID] == nil {
                ProgressView()
                  .withSpotifyStyle(useDiscreetColors: true)
                  .scaleEffect(0.6)
              } else {
                Image(followingState == .isFollowing ?  "heart-filled" : "heart-stroked")
                  .resizable()
              }
            }
            .scaledToFit())
      }
    })
  }

}
