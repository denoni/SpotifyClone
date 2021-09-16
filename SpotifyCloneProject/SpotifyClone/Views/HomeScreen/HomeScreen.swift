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

    if didEverySectionLoaded() == false {
      ProgressView().onAppear {
        homeViewModel.fetchHomeData()
      }
    } else {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading) {
          SmallSongCardsGrid(tracks: getTracksFor(.userTopTracks, homeViewModel: homeViewModel))
            .padding(.horizontal, lateralPadding)
            .padding(.bottom, paddingSectionSeparation)

          RecentlyPlayedScrollView(tracks: getTracksFor(.recentlyPlayed, homeViewModel: homeViewModel))
            .padding(.bottom, paddingSectionSeparation)
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

  func didEverySectionLoaded() -> Bool {
    for key in homeViewModel.isLoading.keys {
      print("KEY > \(key)")
      // If any section still loading, return false
      guard homeViewModel.isLoading[key] != true else {
        return false
      }
    }
    // else, return true
    return true
  }

  func getTracksFor(_ section: HomeViewModel.Sections, homeViewModel: HomeViewModel) -> [SpotifyModel.TrackItem] {
    return !homeViewModel.isLoading[section.rawValue]! ? homeViewModel.medias[section.rawValue]! : []
  }
}



// MARK: - Constants

var lateralPadding: CGFloat = 25
var titleFontSize: CGFloat = 26
var paddingBottomSection: CGFloat = 135
var spacingSmallItems: CGFloat = 12
var spacingBigItems: CGFloat = 20

fileprivate var paddingSectionSeparation: CGFloat = 50

