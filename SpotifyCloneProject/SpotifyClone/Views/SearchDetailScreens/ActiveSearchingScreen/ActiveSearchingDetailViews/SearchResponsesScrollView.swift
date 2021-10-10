//
//  SearchResponsesScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import SwiftUI

struct SearchResponsesScrollView: View {
  @EnvironmentObject var searchDetailVM: SearchDetailViewModel

  var medias: [SpotifyModel.MediaItem] {
    return searchDetailVM.mediaResponses
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack() {
        ForEach(medias) { media in
          ResponseItem(imageURL: media.imageURL,
                       title: media.title,
                       author: media.authorName.joined(separator: " ,"))
        }
      }
      .padding(.bottom, Constants.paddingBottomSection)
      .padding(.top, Constants.paddingLarge)
      .padding(.top, Constants.paddingStandard)
    }
    .disabledBouncing()
  }

  private struct ResponseItem: View {
    let imageURL: String
    let title: String
    let author: String

    var body: some View {
      HStack {
        ZStack(alignment: .center) {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(RemoteImage(urlString: imageURL))
        }
        .frame(width: 60, height: 60)
        VStack(alignment: .leading) {
          Text(title)
            .font(.avenir(.medium, size: Constants.fontMedium))
          Text(author)
            .font(.avenir(.medium, size: Constants.fontSmall))
            .opacity(Constants.opacityStandard)
        }
        .padding(.leading, Constants.paddingSmall)
        Spacer()
        Image("three-dots")
          .resizeToFit()
          .padding(.vertical, Constants.fontSmall)
      }
      .frame(height: 60)
      .padding(.horizontal, Constants.paddingStandard)
    }

  }

}
