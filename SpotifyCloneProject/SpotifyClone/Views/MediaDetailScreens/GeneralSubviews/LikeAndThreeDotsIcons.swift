//
//  LikeAndThreeDotsIcons.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct LikeAndThreeDotsIcons: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var mediaTypeThatIsUsingThisView: APIFetchingUserInfo.ValidMediaType {
    switch mediaDetailVM.mainItem!.mediaType {
    case .playlist:
      return .playlist(userID: mediaDetailVM.mainItem!.id)
    case .album:
      return .album
    default:
      fatalError("Media type is not compatible with this struct.")
    }
  }

  var body: some View {
    HStack(spacing: 30) {
      HeartButton(mediaDetailVM: mediaDetailVM,
                  itemID: mediaDetailVM.mainItem!.id,
                  itemType: mediaTypeThatIsUsingThisView)
      Image("three-dots")
        .resizable()
        .scaledToFit()
      Spacer()
    }
    .frame(height: 25)
    .frame(maxWidth: .infinity)
  }
}
