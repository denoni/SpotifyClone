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
            Text("Album • 2020") // TODO: Add real data
              .font(.avenir(.medium, size: Constants.fontXSmall))
              .lineLimit(1)
              .opacity(Constants.opacityHigh)
          }
          Spacer()
        }
        .padding(.top, 5)
        .onTapGesture {
          switch mediaDetailVM.detailScreenOrigin {
          case .home(let homeVM):
            homeVM.changeSubpageTo(.albumDetail,
                                   mediaDetailVM: mediaDetailVM,
                                   withData: media)
          case .search(let searchVM):
            searchVM.changeSubpageTo(.albumDetail, subPageType: .detail(mediaDetailVM: mediaDetailVM,
                                                                        data: media))
          default:
            fatalError("Missing detail screen origin.")
          }
        }
      }
      SeeMoreButton()
        .padding(.top, 10)
        .opacity(Constants.opacityHigh)
    }
  }
}
