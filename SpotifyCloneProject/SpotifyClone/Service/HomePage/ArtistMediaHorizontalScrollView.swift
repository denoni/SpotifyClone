//
//  ArtistMediaHorizontalScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistMediaHorizontalScrollView: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State var medias: [SpotifyModel.MediaItem]
  var sectionTitle: String

  var body: some View {
    VStack(alignment: .center, spacing: Constants.spacingSmall) {
      Text(sectionTitle)
        .spotifyTitle()
        .lineLimit(1)
        .padding(.trailing, Constants.paddingLarge)
        .padding(.leading, Constants.paddingStandard)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top, spacing: Constants.spacingLarge) {
//          Spacer(minLength: Constants.paddingStandard)
          ForEach(medias) { media in
            SmallSongItem(imageURL: media.imageURL,
                          title: media.title)
              .onTapGesture {
                switch mediaDetailVM.detailScreenOrigin {
                case .home(let homeVM):
                  homeVM.changeSubpageTo(.playlistDetail,
                                         mediaDetailVM: mediaDetailVM,
                                         withData: media)
                case .search(let searchVM):
                  searchVM.changeSubpageTo(.playlistDetail, subPageType: .detail(mediaDetailVM: mediaDetailVM,
                                                                                 data: media))
                default:
                  fatalError("Missing detail screen origin.")
                }
              }
            .buttonStyle(PlainButtonStyle())
          }
        }
        .padding(.horizontal, Constants.paddingStandard)
      }
    }
    .frame(height: 250)
  }
}
