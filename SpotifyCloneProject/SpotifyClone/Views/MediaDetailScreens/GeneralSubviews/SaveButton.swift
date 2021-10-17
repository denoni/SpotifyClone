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

  var followingState: MediaDetailViewModel.CurrentFollowingState {
    Utility.checkIfIsFollowingItem(itemID, mediaDetailVM: mediaDetailVM)
  } 

  var body: some View {
    if followingState == .isFollowing {
      Button(action: { MediaDetailViewModel.UserInfoAPICalls.changeFollowingState(to: .unfollow,
                                                                                  in: itemType,
                                                                                  mediaVM: mediaDetailVM,
                                                                                  itemID: itemID) }) {
        Image(systemName: "checkmark.circle.fill")
          .resizable()
          .foregroundColor(.spotifyGreen)
          .frame(width: 25, height: 25)
      }
    } else {
      Button(action: { MediaDetailViewModel.UserInfoAPICalls.changeFollowingState(to: .follow,
                                                                                  in: itemType,
                                                                                  mediaVM: mediaDetailVM,
                                                                                  itemID: itemID) }) {
        Image("plus-circle")
          .resizable()
          .frame(width: 25, height: 25)
      }
    }
  }
  
}
