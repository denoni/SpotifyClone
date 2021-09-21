//
//  BrowseAllSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct BrowseAllSection: View {
  var title: String
  @State var playlists: [SpotifyModel.PlaylistItem]
  @State var colors: [Color]
  var numberOfItems: Range<Int> { 0 ..< playlists.count / 2 }

  var body: some View {
    VStack {
      Text(title).font(.avenir(.heavy, size: 18))
        .frame(maxWidth: .infinity, alignment: .topLeading)
      VStack(spacing: lateralPadding) {
        ForEach(numberOfItems) { pairIndex in
          ColorfulCardPair(titles: [playlists[pairIndex * 2].name, playlists[pairIndex * 2 + 1].name],
                           imagesURL: [playlists[pairIndex * 2].imageURL, playlists[pairIndex * 2 + 1].imageURL],
                           colors: [colors[pairIndex * 2], colors[pairIndex * 2 + 1]])
        }
      }
    }
    .padding(.horizontal, lateralPadding)
  }
}

