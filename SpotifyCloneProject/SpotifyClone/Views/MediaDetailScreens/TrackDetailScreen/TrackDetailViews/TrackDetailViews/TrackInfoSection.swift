//
//  TrackInfoSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct TrackInfoSection: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  var songName: String
  var authors: [Artist]
  var isLiked: Bool
  var isExplicit: Bool
  var isSmallDisplay: Bool = false

  var body: some View {
    Group {
      HStack {
        VStack(alignment: .leading,
               spacing: 0) {
          MediaTitle(mediaTitle: songName, useSmallerFont: isSmallDisplay)
            .padding(.trailing, Constants.paddingStandard)

          AuthorNames(authors: authors, useSmallerFont: isSmallDisplay, isExplicit: isExplicit)
        }

      }.frame(
        maxWidth: .infinity,
        alignment: .topLeading
      )
      Image(isLiked ? "heart-filled" : "heart-stroked")
        .resizeToFit()
        .padding(3)
        .frame(height: 30)
    }
  }
}

struct AuthorNames: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  let authors: [Artist]
  let useSmallerFont: Bool
  let isExplicit: Bool

  var isLoadingArtistBasicInfo: Bool {
    mediaDetailVM.isLoading[.artistBasicInfo(.artistBasicInfo)]!
  }

  var body: some View {
    HStack(spacing: 0) {
      ExplicitIcon(isExplicit: isExplicit)
        .padding(.trailing, isExplicit ? 5 : 0)
      ForEach(0 ..< authors.count) { index in
                                          // checks if should put ", " or not(we don't put when the current item is the last one)
        Text("\(authors[index].name)" + "\(index == authors.count - 1 ? "" : ", ")")
          .font(.avenir(.medium, size: useSmallerFont ? Constants.fontSmall : Constants.fontMedium))
          .foregroundColor(.white)
          .tracking(0.5)
          .lineLimit(1)
          .onTapGesture {
            if isLoadingArtistBasicInfo == false {
              navigateToArtistProfile(itemIndex: index)
            }
          }
      }
    }
    .opacity(Constants.opacityStandard)
    .padding(.trailing, Constants.paddingStandard)
    .redacted(reason: isLoadingArtistBasicInfo ? .placeholder : [])
  }

  private func navigateToArtistProfile(itemIndex: Int) {
    let data = mediaDetailVM.mediaCollection[.artistBasicInfo(.artistBasicInfo)]!
    switch mediaDetailVM.detailScreenOrigin {
    case .home(let homeVM):
      homeVM.changeSubpageTo(.artistDetail,
                             mediaDetailVM: mediaDetailVM,
                             withData: data[itemIndex])
    case .search(let searchVM):
      searchVM.changeSubpageTo(.artistDetail, subPageType: .detail(mediaDetailVM: mediaDetailVM,
                                                                   data: data[itemIndex]))
    default:
      fatalError("Missing detail screen origin.")
    }
  }

}
