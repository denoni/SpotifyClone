//
//  FilterSelectionBar.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/25/21.
//

import SwiftUI

struct FilterSelectionBar<CurrentViewModel>: View where CurrentViewModel: FilterableViewModelProtocol {
  @ObservedObject var currentViewModel: CurrentViewModel

  private var paddingScale: CGFloat {
    let scrollScale = currentViewModel.currentScrollPosition / UIScreen.main.bounds.height * 100
    return scrollScale <= Constants.paddingSmall ? scrollScale : Constants.paddingSmall
  }

  private var opacityScale: CGFloat {
    let scrollScale = currentViewModel.currentScrollPosition / UIScreen.main.bounds.height * 15
    return scrollScale <= 1 ? scrollScale : 1
  }

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      Group {
        HStack(spacing: Constants.spacingSmall) {
          FilterCapsuleButton(text: "All", mediaType: nil, currentViewModel: currentViewModel)
          FilterCapsuleButton(text: "Playlists", mediaType: .playlist, currentViewModel: currentViewModel)
          FilterCapsuleButton(text: "Artists", mediaType: .artist, currentViewModel: currentViewModel)
          FilterCapsuleButton(text: "Albums", mediaType: .album, currentViewModel: currentViewModel)
          FilterCapsuleButton(text: "Shows", mediaType: .show, currentViewModel: currentViewModel)
          if CurrentViewModel.self == ActiveSearchViewModel.self {
            FilterCapsuleButton(text: "Episodes", mediaType: .episode, currentViewModel: currentViewModel)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Constants.paddingStandard)
      }
    }
    .padding(.top, Constants.paddingSmall - paddingScale)
    .opacity(1 - opacityScale)
    .padding(.bottom, -5)
  }

  private struct FilterCapsuleButton: View {
    var text: String
    var mediaType: SpotifyModel.MediaTypes?
    @ObservedObject var currentViewModel: CurrentViewModel
    private var isTapped: Bool { currentViewModel.selectedMediaTypeFilter == mediaType }

    private let height: CGFloat = 35
    private var heightScale: CGFloat {
      let scrollScale = currentViewModel.currentScrollPosition / UIScreen.main.bounds.height * height * 10
      return scrollScale <= height ? scrollScale : height
    }

    var body: some View {
      Button(action: { currentViewModel.selectedMediaTypeFilter = mediaType },
             label: {
        Text(text)
          .font(.avenir(.medium, size: Constants.fontXSmall))
          .padding(.horizontal, Constants.paddingSmall)
          .foregroundColor(.white)
          .frame(height: height - heightScale)
          .opacity(isTapped ? 1 : Constants.opacityLow)
        // if isTapped -> show green filled background, else show white stroked border
          .background(isTapped ? Capsule().strokeBorder(Color.clear) : Capsule().strokeBorder(Color.white))
          .background(isTapped ? Capsule().foregroundColor(.spotifyGreen) : Capsule().foregroundColor(.clear))
      })
      .buttonStyle(PlainButtonStyle())
    }
  }

}
