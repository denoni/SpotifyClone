//
//  HomeScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

// TODO: Reduce duplicated code
// TODO: Convert to arrays and render using ForEach
// TODO: Try to use EnvironmentObject instead of ObservedObject
import SwiftUI

struct HomeScreen: View {
  @EnvironmentObject var homeVM: HomeViewModel

  var body: some View {
    switch homeVM.currentSubPage {
    case .none:
      HomeScreenDefault()
    case .playlistDetail:
      PlaylistDetailScreen()
    case .trackDetail:
      TrackDetailScreen()
    case .albumDetail:
      AlbumDetailScreen()
    case .showDetail:
      ShowsDetailScreen()
    case .artistDetail:
      ArtistDetailScreen()
    }
  }
  
  
  
  // MARK: - Auxiliary Functions
  
  struct HomeScreenDefault: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @State var scrollViewPosition = CGFloat.zero

    var body: some View {
      RadialGradientBackground(color: Color(homeVM.veryFirstImageInfo.image?.averageColor! ?? UIColor.clear))
      
      if didEverySectionLoaded() == false {
        ProgressView()
          .withSpotifyStyle()
          .onAppear {
            homeVM.fetchHomeData()
          }
      } else {
        ZStack {
          ReadableScrollView(currentPosition: $scrollViewPosition) {
            LazyVStack(alignment: .leading, spacing: paddingSectionSeparation) {
              Group {
                SmallSongCardsGrid(medias: getTracksFor(.smallSongCards))
                  .padding(.horizontal, lateralPadding)
                RecentlyPlayedScrollView(medias: getTracksFor(.recentlyPlayed))
                BigSongCoversScrollView(section: .newReleases,
                                        showArtistName: true)
                BigSongCoversScrollView(section: .userFavoriteTracks)
                BigSongCoversScrollView(section: .topPodcasts)
                // TODO: Stop using previewURL to store the featured playlist title
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
            .padding(.vertical, lateralPadding)
            .padding(.bottom, paddingBottomSection)
          }
          TopBar(animateOpacityWith: scrollViewPosition)

        }
      }
    }
    
    func didEverySectionLoaded() -> Bool {
      for key in homeVM.isLoading.keys {
        // If any section still loading, return false
        guard homeVM.isLoading[key] != true else {
          return false
        }
      }
      // else, return true
      return true
    }
    
    func getTracksFor(_ section: HomeViewModel.Section) -> [SpotifyModel.MediaItem] {
      return !homeVM.isLoading[section]! ? homeVM.mediaCollection[section]! : []
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

