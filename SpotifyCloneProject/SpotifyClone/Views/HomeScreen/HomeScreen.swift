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

    var body: some View {
      RadialGradientBackground(color: Color(homeVM.veryFirstImageInfo.image?.averageColor! ?? UIColor.clear))
      
      if didEverySectionLoaded() == false {
        ProgressView()
          .withSpotifyStyle()
          .onAppear {
            homeVM.fetchHomeData()
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
              BigSongCoversScrollView(section: .newReleases,
                                      showArtistName: true)
                .padding(.bottom, paddingSectionSeparation)
              
              // MARK: User Favorite Tracks
              BigSongCoversScrollView(section: .userFavoriteTracks)
                .padding(.bottom, paddingSectionSeparation)
              
              // MARK: Top Podcasts
              BigSongCoversScrollView(section: .topPodcasts)
                .padding(.bottom, paddingSectionSeparation)
              
              // MARK: Featured Playlists
              BigSongCoversScrollView(section: .featuredPlaylists,
                                      // TODO: Stop using previewURL to store the featured playlist title
                                      sectionTitle: homeVM.mediaCollection[.featuredPlaylists]!.first!.previewURL)
                .padding(.bottom, paddingSectionSeparation)
              
              // MARK: Artist's Top Tracks
              RecommendedArtistScrollView(medias: getTracksFor(.artistTopTracks),
                                          sectionTitle: HomeViewModel.Section.artistTopTracks.rawValue)
                .padding(.bottom, paddingSectionSeparation)
              
              // MARK: User Favorite Artists
              BigSongCoversScrollView(section: .userFavoriteArtists)
                .padding(.bottom, paddingSectionSeparation)
            }
            Group {
              // MARK: Playlist Rewind 2010s
              BigSongCoversScrollView(section: .playlistRewind2010s)
                .padding(.bottom, paddingSectionSeparation)
              
              // MARK: Playlist Rewind 2000s
              BigSongCoversScrollView(section: .playlistRewind2000s)
                .padding(.bottom, paddingSectionSeparation)
              
              // MARK: Playlist Rewind 90s
              BigSongCoversScrollView(section: .playlistRewind90s)
                .padding(.bottom, paddingSectionSeparation)
              
              // MARK: Playlist Rewind 80s
              BigSongCoversScrollView(section: .playlistRewind80s)
                .padding(.bottom, paddingSectionSeparation)
              
              // MARK: Playlist Rewind 70s
              BigSongCoversScrollView(section: .playlistRewind70s)
                .padding(.bottom, paddingSectionSeparation)
              
              // MARK: Playlist This Is X
              BigSongCoversScrollView(section: .playlistThisIsX)
                .padding(.bottom, paddingSectionSeparation)
            }
          }
          .padding(.vertical, lateralPadding)
          .padding(.bottom, paddingBottomSection)
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

