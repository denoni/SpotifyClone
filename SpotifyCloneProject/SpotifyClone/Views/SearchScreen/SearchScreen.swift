//
//  SearchScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/2/21.
//

import SwiftUI

struct SearchScreen: View {
  @EnvironmentObject var searchVM: SearchViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var body: some View {
    switch searchVM.currentSubPage {
    case .none:
      SearchScreenDefault()

    case .activeSearching:
      ActiveSearchingScreen()

    case .transitionScreen:
      ProgressView()
        .withSpotifyStyle(useDiscreetColors: true)

    case .trackDetail:
      TrackDetailScreen(detailScreenOrigin: .search(searchVM: searchVM),
                        mediaDetailVM: mediaDetailVM)
    case .albumDetail:
      AlbumDetailScreen(detailScreenOrigin: .search(searchVM: searchVM),
                        mediaDetailVM: mediaDetailVM)
    case .showDetail:
      ShowsDetailScreen(detailScreenOrigin: .search(searchVM: searchVM),
                        mediaDetailVM: mediaDetailVM)
    case .artistDetail:
      ArtistDetailScreen(detailScreenOrigin: .search(searchVM: searchVM),
                         mediaDetailVM: mediaDetailVM)
    case .playlistDetail:
      PlaylistDetailScreen(detailScreenOrigin: .search(searchVM: searchVM),
                           mediaDetailVM: mediaDetailVM)
    case .episodeDetail:
      EpisodeDetailScreen(detailScreenOrigin: .search(searchVM: searchVM),
                          mediaDetailVM: mediaDetailVM)
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
//            TopGenresSection(title: "Top Genres")
//              .padding(.bottom, Constants.paddingSmall)
//            PopularPodcastSection(title: "Popular Podcast Categories")
//              .padding(.bottom, Constants.paddingSmall)
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
