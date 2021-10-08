//
//  SearchScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/2/21.
//

// TODO: Make the custom view structures more usable with arguments when called
// TODO: Make all group of cards just one ColorfulCardsSection

import SwiftUI

struct SearchScreen: View {
  @EnvironmentObject var searchVM: SearchViewModel

  var body: some View {
    switch searchVM.currentSubPage {
    case .none:
      SearchScreenDefault()
    case .activeSearching:
      ActiveSearchingScreen()
    }
  }



  // MARK: - Search Screen Default

  struct SearchScreenDefault: View {
    @EnvironmentObject var searchVM: SearchViewModel

    var body: some View {
      if searchVM.isLoading == true {
        ProgressView()
          .withSpotifyStyle(useDiscreetColors: true)
          .onAppear {
            searchVM.getCategoriesData()
          }
      } else {
        ScrollView(showsIndicators: false) {
          LazyVStack(alignment: .leading) {
            SearchBarSection()
              .padding(.bottom, Constants.paddingStandard)
            TopGenresSection(title: "Top Genres")
              .padding(.bottom, Constants.paddingSmall)
            PopularPodcastSection(title: "Popular Podcast Categories")
              .padding(.bottom, Constants.paddingSmall)
            BrowseAllSection(title: "Browse All",
                             playlists: searchVM.playlists,
                             colors: searchVM.colors)
              .padding(.bottom, Constants.paddingBottomSection)
          }.padding(.vertical, Constants.paddingStandard)
        }
      }
    }
  }

}
