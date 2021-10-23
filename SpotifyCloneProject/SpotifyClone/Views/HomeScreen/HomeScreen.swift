//
//  HomeScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

import SwiftUI

struct HomeScreen: View {
  @EnvironmentObject var homeVM: HomeViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var body: some View {
    switch homeVM.currentSubPage {
    case .none:
      HomeScreenDefault()

    case .transitionScreen:
      ProgressView()
        .withSpotifyStyle(useDiscreetColors: true)

    case .playlistDetail:
      PlaylistDetailScreen(detailScreenOrigin: .home(homeVM: homeVM),
                           mediaDetailVM: mediaDetailVM)
    case .trackDetail:
      TrackDetailScreen(detailScreenOrigin: .home(homeVM: homeVM),
                        mediaDetailVM: mediaDetailVM)
    case .albumDetail:
      AlbumDetailScreen(detailScreenOrigin: .home(homeVM: homeVM),
                        mediaDetailVM: mediaDetailVM)
    case .showDetail:
      ShowsDetailScreen(detailScreenOrigin: .home(homeVM: homeVM),
                        mediaDetailVM: mediaDetailVM)
    case .artistDetail:
      ArtistDetailScreen(detailScreenOrigin: .home(homeVM: homeVM),
                         mediaDetailVM: mediaDetailVM)
    case .episodeDetail:
      EpisodeDetailScreen(detailScreenOrigin: .home(homeVM: homeVM),
                          mediaDetailVM: mediaDetailVM)
    }
  }
  
  
  
  // MARK: - Auxiliary Functions
  
  struct HomeScreenDefault: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @State var scrollViewPosition = CGFloat.zero

    var body: some View {
      RadialGradientBackground(color: Color(homeVM.imageColorModel.image?.averageColor! ?? UIColor.clear))
      
      if didEverySectionLoaded() == false {
        ProgressView()
          .withSpotifyStyle()
          .onAppear {
            homeVM.fetchHomeData()
          }
      } else {
        ZStack {
          ReadableScrollView(currentPosition: $scrollViewPosition) {
            LazyVStack(alignment: .leading, spacing: Constants.paddingStandard) {
              Group {
                SmallSongCardsGrid(medias: getTracksFor(.smallSongCards))
                  .padding(.horizontal, Constants.paddingStandard)
                RecentlyPlayedScrollView(medias: getTracksFor(.recentlyPlayed))
                BigSongCoversScrollView(section: .newReleases,
                                        showArtistName: true)
                BigSongCoversScrollView(section: .userFavoriteTracks)
                BigSongCoversScrollView(section: .topPodcasts)
                BigSongCoversScrollView(section: .featuredPlaylists,
                                        sectionTitle: homeVM.mediaCollection[.featuredPlaylists]!.first!.previewURL)
                RecommendedArtistScrollView(medias: getTracksFor(.artistTopTracks),
                                            sectionTitle: HomeViewModel.Section.artistTopTracks.rawValue)
                BigSongCoversScrollView(section: .userFavoriteArtists)
              }
              Group {
                BigSongCoversScrollView(section: .playlistRewind2010s)
                BigSongCoversScrollView(section: .playlistRewind2000s)
                BigSongCoversScrollView(section: .playlistRewind90s)
                BigSongCoversScrollView(section: .playlistRewind80s)
                BigSongCoversScrollView(section: .playlistRewind70s)
                BigSongCoversScrollView(section: .playlistThisIsX)
              }
            }
            .padding(.vertical, Constants.paddingStandard)
            .padding(.bottom, Constants.paddingBottomSection)
          }
          TopBar(animateOpacityWith: scrollViewPosition)

        }
      }
    }



    // MARK: Auxiliary functions
    private func didEverySectionLoaded() -> Bool {
      for key in homeVM.isLoading.keys {
        // If any section still loading, return false
        guard homeVM.isLoading[key] != true else {
          return false
        }
      }
      // else, return true
      return true
    }
    
    private func getTracksFor(_ section: HomeViewModel.Section) -> [SpotifyModel.MediaItem] {
      return !homeVM.isLoading[section]! ? homeVM.mediaCollection[section]! : []
    }
  }
  
}
