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
  @EnvironmentObject var searchViewModel: SearchViewModel

  var body: some View {
    RadialGradientBackground()
    if searchViewModel.isLoading == true {
      ProgressView()
        .withSpotifyStyle(useDiscreetColors: true)
        .onAppear {
          searchViewModel.getCategoriesData()
        }
    } else {
      ScrollView(showsIndicators: false) {
        LazyVStack(alignment: .leading) {
          SearchSection()
            .padding(.bottom, 30)
          TopGenresSection(title: "Top Genres")
            .padding(.bottom, 10)
          PopularPodcastSection(title: "Popular Podcast Categories")
            .padding(.bottom, 10)
          BrowseAllSection(title: "Browse All",
                           playlists: searchViewModel.playlists,
                           colors: searchViewModel.colors)
            .padding(.bottom, paddingBottomSection)
        }.padding(.vertical, lateralPadding)
      }
    }
  }
}
