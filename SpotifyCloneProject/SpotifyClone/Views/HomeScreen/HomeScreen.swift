//
//  HomeScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

// TODO: Reduce duplicated code
// TODO: Convert to arrays and render using ForEach
// TODO: Separate into different items

import SwiftUI

struct HomeScreen: View {
  @StateObject var homeViewModel: HomeViewModel


  var body: some View {
    RadialGradientBackground()
    if homeViewModel.isLoading {
      ProgressView().onAppear {
        homeViewModel.fetchHomeData()
      }
    } else {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading) {
          SmallSongCardsGrid(tracks: !homeViewModel.isLoading ? homeViewModel.medias["Small Song Card Items"]! : [])
            .padding(.horizontal, lateralPadding)
            .padding(.bottom, paddingSectionSeparation)

  //        RecentlyPlayedScrollView(homeViewModel: homeViewModel)
  //          .padding(.bottom, paddingSectionSeparation)
  //        TopPodcastScrollView(homeViewModel: homeViewModel)
  //          .padding(.bottom, paddingSectionSeparation)
  //        RecommendedArtistScrollView(homeViewModel: homeViewModel)
  //          .padding(.bottom, paddingSectionSeparation)
  //        BigSongCoversScrollView(homeViewModel: homeViewModel)
  //          .padding(.bottom, paddingBottomSection)
        }.padding(.vertical, lateralPadding)
      }
    }
  }
}



// MARK: - Constants

var lateralPadding: CGFloat = 25
var titleFontSize: CGFloat = 26
var paddingBottomSection: CGFloat = 135
var spacingSmallItems: CGFloat = 12
var spacingBigItems: CGFloat = 20

fileprivate var paddingSectionSeparation: CGFloat = 50

