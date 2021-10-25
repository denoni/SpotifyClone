//
//  SearchResponsesScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import SwiftUI
import UIKit

struct SearchResponsesScrollView: View {
  @EnvironmentObject var searchVM: SearchViewModel
  @EnvironmentObject var activeSearchVM: ActiveSearchViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State private var scrollPosition: CGFloat = 0

  var medias: [SpotifyModel.MediaItem] {
    return activeSearchVM.mediaResponses
  }

  func getMediaType(for media: SpotifyModel.MediaItem) -> SearchViewModel.SearchSubpage {
    switch media.mediaType {
    case .track:
      return SearchViewModel.SearchSubpage.trackDetail
    case .album:
      return SearchViewModel.SearchSubpage.albumDetail
    case .playlist:
      return SearchViewModel.SearchSubpage.playlistDetail
    case .show:
      return SearchViewModel.SearchSubpage.showDetail
    case .artist:
      return SearchViewModel.SearchSubpage.artistDetail
    case .episode:
      return SearchViewModel.SearchSubpage.episodeDetail
    }
  }

  var body: some View {
    ZStack {
      Color.clear
      ReadableScrollView(currentPosition: $scrollPosition) {
        LazyVStack() {
          ForEach(medias) { media in
            SearchResponseItem(imageURL: media.imageURL,
                               title: media.title,
                               author: media.authorName.joined(separator: " ,"),
                               mediaType: media.mediaType)
              .onTapGesture {
                searchVM.changeSubpageTo(getMediaType(for: media), subPageType: .detail(mediaDetailVM: mediaDetailVM, data: media))
              }
          }
        }
        .padding(.bottom, Constants.paddingBottomSection)
        .padding(.top, Constants.paddingLarge)
        .padding(.top, Constants.paddingStandard)
        // Closes keyboard when user scrolls
        .onChange(of: scrollPosition) { _ in
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
}
