//
//  HomeScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

// TODO: Reduce duplicated code
// TODO: Convert to arrays and render using ForEach

import SwiftUI

struct HomeScreen: View {
  @ObservedObject var homeViewModel: HomeViewModel
  
  var body: some View {
    switch homeViewModel.currentSubPage {
    case .none:
      HomeScreenDefault(homeViewModel: homeViewModel)
    case .mediaDetail:
      MediaDetailScreen(homeViewModel: homeViewModel)
    }
  }



  // MARK: - Auxiliary Functions

  struct HomeScreenDefault: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        RadialGradientBackground()

        if didEverySectionLoaded() == false {
          ProgressView()
            .withSpotifyStyle()
            .onAppear {
              homeViewModel.fetchHomeData()
            }
        } else {
          ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
              Group {
                // MARK: Small Song Cards
                SmallSongCardsGrid(medias: getTracksFor(.smallSongCards))
                  .padding(.horizontal, lateralPadding)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: Recently Played
                RecentlyPlayedScrollView(medias: getTracksFor(.recentlyPlayed))
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: New Releases
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .newReleases)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: User Favorite Tracks
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .userFavoriteTracks)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: Top Podcasts
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .topPodcasts)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: Featured Playlists
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .featuredPlaylists,
                                        sectionTitle: homeViewModel.mediaCollection[.featuredPlaylists]!.first!.author)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: Artist's Top Tracks
                RecommendedArtistScrollView(medias: getTracksFor(.artistTopTracks),
                                            sectionTitle: HomeViewModel.Section.artistTopTracks.rawValue)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: User Favorite Artists
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .userFavoriteArtists)
                  .padding(.bottom, paddingSectionSeparation)
              }
              Group {
                // MARK: Playlist Rewind 2010s
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .playlistRewind2010s)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: Playlist Rewind 2000s
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .playlistRewind2000s)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: Playlist Rewind 90s
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .playlistRewind90s)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: Playlist Rewind 80s
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .playlistRewind80s)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: Playlist Rewind 70s
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .playlistRewind70s)
                  .padding(.bottom, paddingSectionSeparation)

                // MARK: Playlist This Is X
                BigSongCoversScrollView(homeViewModel: homeViewModel,
                                        section: .playlistThisIsX)
                  .padding(.bottom, paddingSectionSeparation)
              }
            }
            .padding(.vertical, lateralPadding)
            .padding(.bottom, paddingBottomSection)
          }
        }
    }

    func didEverySectionLoaded() -> Bool {
      for key in homeViewModel.isLoading.keys {
        // If any section still loading, return false
        guard homeViewModel.isLoading[key] != true else {
          return false
        }
      }
      // else, return true
      return true
    }

    func getTracksFor(_ section: HomeViewModel.Section) -> [SpotifyModel.MediaItem] {
      return !homeViewModel.isLoading[section]! ? homeViewModel.mediaCollection[section]! : []
    }
  }

}



// MARK: - Constants

var lateralPadding: CGFloat = 25
var titleFontSize: CGFloat = 26
var paddingBottomSection: CGFloat = 135
var spacingSmallItems: CGFloat = 12
var spacingBigItems: CGFloat = 20

fileprivate var paddingSectionSeparation: CGFloat = 25

