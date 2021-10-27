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

  var medias: [SpotifyModel.MediaItem] {
    guard activeSearchVM.selectedMediaTypeFilter != nil else {
      return activeSearchVM.mediaResponses
    }
    return activeSearchVM.mediaResponses.filter { $0.mediaType == activeSearchVM.selectedMediaTypeFilter! }
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
      ReadableScrollView(currentPosition: $activeSearchVM.currentScrollPosition) {
        LazyVStack {
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
        .padding(.top, 100 + Constants.paddingLarge)
        .padding(.bottom, Constants.paddingBottomSection)
        // Closes keyboard when user scrolls
        .onChange(of: activeSearchVM.currentScrollPosition) { _ in
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

}
