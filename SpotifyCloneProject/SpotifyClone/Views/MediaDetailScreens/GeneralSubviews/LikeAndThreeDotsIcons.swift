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
      if mediaDetailVM.errorOccurredWhileTryingToFollow == true {
        Image(systemName: "xmark.octagon.fill")
          .resizable()
          .aspectRatio(1/1, contentMode: .fit)
          .frame(width: 25)
      } else {
        Button(action: {  MediaDetailViewModel.UserInfoAPICalls.follow(mediaTypeThatIsUsingThisView, mediaVM: mediaDetailVM) }) {
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
        }

      }

      Image("three-dots")
        .resizable()
        .scaledToFit()
      Spacer()
    }
    .frame(height: 25)
    .frame(maxWidth: .infinity)
  }
}
