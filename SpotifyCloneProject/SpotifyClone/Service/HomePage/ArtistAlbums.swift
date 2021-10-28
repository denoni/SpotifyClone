//
//  ArtistAlbums.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistAlbums: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  let medias: [SpotifyModel.MediaItem]

  var body: some View {
    VStack {
      ForEach(medias) { media in
        HStack(spacing: Constants.spacingSmall) {
          VStack(alignment: .leading) {
            Text(media.title)
              .font(.avenir(.medium, size: Constants.fontSmall))
              .lineLimit(1)
              .padding(.trailing, Constants.paddingLarge)
            Group {
              let releaseDate = Utility.getSpelledOutDate(from: SpotifyModel.getAlbumDetails(for: media).releaseDate,
                                                          onlyYear: true)
              let numberOfTracks = "\(SpotifyModel.getAlbumDetails(for: media).numberOfTracks) tracks"
              Text("Album • \(releaseDate != "" ? releaseDate : numberOfTracks)")
                .font(.avenir(.medium, size: Constants.fontXSmall))
                .lineLimit(1)
                .opacity(Constants.opacityHigh)
            }
          }
          Spacer()
        }
        .padding(.top, 5)
        .onTapGesture {
          Utility.changeSubpage(to: .albumDetail, mediaDetailVM: mediaDetailVM, withData: media)
        }
      }
      SeeMoreButton()
        .padding(.top, 10)
        .opacity(Constants.opacityHigh)
    }
  }
}
