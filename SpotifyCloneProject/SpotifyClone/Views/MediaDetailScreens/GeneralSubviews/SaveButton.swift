//
//  SaveButton.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/17/21.
//

import SwiftUI

struct SaveButton: View {
  @StateObject var mediaDetailVM: MediaDetailViewModel
  var itemID: String
  var itemType: APIFetchingUserInfo.ValidMediaType

  private var followingState: MediaDetailViewModel.CurrentFollowingState {
    Utility.checkIfIsFollowingItem(itemID, mediaDetailVM: mediaDetailVM)
  }

  var body: some View {
    if followingState == .isFollowing {
      Button(action: { MediaDetailAPICalls.UserInfoAPICalls.changeFollowingState(to: .unfollow,
                                                                                 in: itemType,
                                                                                 mediaDetailVM: mediaDetailVM,
                                                                                 itemID: itemID) },
             label: {
        Image(systemName: "checkmark.circle.fill")
          .resizable()
          .foregroundColor(.spotifyGreen)
          .frame(width: 25, height: 25)
      })
    } else {
      Button(action: { MediaDetailAPICalls.UserInfoAPICalls.changeFollowingState(to: .follow,
                                                                                 in: itemType,
                                                                                 mediaDetailVM: mediaDetailVM,
                                                                                 itemID: itemID) },
             label: {
        Image("plus-circle")
          .resizable()
          .frame(width: 25, height: 25)
      })
    }
  }

}
