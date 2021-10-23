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

  private var mediaTypeThatIsUsingThisView: APIFetchingUserInfo.ValidMediaType {
    switch mediaDetailVM.mainItem!.mediaType {
    case .artist:
      return .artist
    case .show:
      return .show
    default:
      fatalError("Media type is not compatible with this struct.")
    }
  }

  private var followingState: MediaDetailViewModel.CurrentFollowingState {
    guard mediaDetailVM.followedIDs[mediaDetailVM.mainItem!.id] != nil else { return .isNotFollowing }
    return mediaDetailVM.followedIDs[mediaDetailVM.mainItem!.id]!
  }

  var body: some View {
    HStack(spacing: 30) {
      FollowButton(mediaDetailVM: mediaDetailVM,
                   itemID: mediaDetailVM.mainItem!.id,
                   itemType: mediaTypeThatIsUsingThisView)
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
