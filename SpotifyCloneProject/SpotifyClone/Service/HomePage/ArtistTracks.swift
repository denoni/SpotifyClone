//
//  ArtistTracks.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistTracks: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State var medias: [SpotifyModel.MediaItem]

  var body: some View {
    VStack {
      ForEach(medias) { media in
        HStack(spacing: Constants.spacingSmall) {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(RemoteImage(urlString: media.imageURL))
            .frame(width: 80, height: 80)
          VStack(alignment: .leading) {
            Text(media.title)
              .font(.avenir(.medium, size: Constants.fontSmall))
              .lineLimit(1)
              .padding(.trailing, Constants.paddingLarge)
            Text("Single • 2020") // TODO: Show real data
              .font(.avenir(.medium, size: Constants.fontXSmall))
              .opacity(Constants.opacityHigh)
              .lineLimit(1)
          }
          Spacer()
        }
        .frame(height: 100)
        .padding(.top, 5)
        .onTapGesture {
          switch mediaDetailVM.detailScreenOrigin {
          case .home(let homeVM):
            homeVM.changeSubpageTo(.trackDetail,
                                   mediaDetailVM: mediaDetailVM,
                                   withData: media)
          case .search(let searchVM):
            searchVM.changeSubpageTo(.trackDetail, subPageType: .detail(mediaDetailVM: mediaDetailVM,
                                                                        data: media))
          default:
            fatalError("Missing detail screen origin.")
          }
        }
      }
      // TODO: Make button work
      SeeMoreButton()
        .padding(.top, 5)
        .opacity(Constants.opacityHigh)
    }
  }
}



