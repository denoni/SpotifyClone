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
          SearchResponseItem(imageURL: media.imageURL,
                             title: media.title,
                             author: media.authorName.joined(separator: " ,"),
                             mediaType: media.mediaType)
        }
      }
      .padding(.bottom, Constants.paddingBottomSection)
      .padding(.top, Constants.paddingLarge)
      .padding(.top, Constants.paddingStandard)
    }
    .disabledBouncing()
  }
  
}
