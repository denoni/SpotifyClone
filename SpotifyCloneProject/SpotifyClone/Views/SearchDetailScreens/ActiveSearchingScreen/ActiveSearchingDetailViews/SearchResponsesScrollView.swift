//
//  SearchResponsesScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import SwiftUI

struct SearchResponsesScrollView: View {

  static let mediaItem = (trackTitle: "Track Title", trackAuthor: "Author", imageURL: "https://i.scdn.co/image/ab67616d0000b2733db35792fa2e91722e9897b1")

  let medias = Array(repeating: mediaItem, count: 15)

  var body: some View {
    ScrollView {
      LazyVStack() {
        ForEach(0 ..< medias.count) { index in
          ResponseItem(imageURL: medias[index].imageURL,
                       title: medias[index].trackTitle,
                       author: medias[index].trackAuthor)
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
            .padding(.leading, 10)
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
