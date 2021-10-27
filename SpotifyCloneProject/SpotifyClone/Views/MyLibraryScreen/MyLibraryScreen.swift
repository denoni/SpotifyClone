//
//  MyLibraryScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/19/21.
//

import SwiftUI

struct MyLibraryScreen: View {
  @EnvironmentObject var myLibraryVM: MyLibraryViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var body: some View {
    switch myLibraryVM.currentSubPage {
    case .none:
      MyLibraryScreenDefault()

    case .transitionScreen:
      ProgressView()
        .withSpotifyStyle(useDiscreetColors: true)

    case .likedSongs:
      LikedSongsScrollScreen()

    case .yourEpisodes:
      YourEpisodesScrollScreen()

    case .playlistDetail:
      PlaylistDetailScreen(detailScreenOrigin: .myLibrary(myLibraryVM: myLibraryVM),
                           mediaDetailVM: mediaDetailVM)
    case .trackDetail:
      TrackDetailScreen(detailScreenOrigin: .myLibrary(myLibraryVM: myLibraryVM),
                        mediaDetailVM: mediaDetailVM)
    case .albumDetail:
      AlbumDetailScreen(detailScreenOrigin: .myLibrary(myLibraryVM: myLibraryVM),
                        mediaDetailVM: mediaDetailVM)
    case .showDetail:
      ShowsDetailScreen(detailScreenOrigin: .myLibrary(myLibraryVM: myLibraryVM),
                        mediaDetailVM: mediaDetailVM)
    case .artistDetail:
      ArtistDetailScreen(detailScreenOrigin: .myLibrary(myLibraryVM: myLibraryVM),
                         mediaDetailVM: mediaDetailVM)
    case .episodeDetail:
      EpisodeDetailScreen(detailScreenOrigin: .myLibrary(myLibraryVM: myLibraryVM),
                          mediaDetailVM: mediaDetailVM)
    }
  }

  struct MyLibraryScreenDefault: View {
    @EnvironmentObject var myLibraryVM: MyLibraryViewModel

    var body: some View {
      VStack {
        ZStack {
          if didEverySectionLoaded() == false {
            ProgressView()
              .withSpotifyStyle()
              .onAppear {
                myLibraryVM.fetchMyLibraryData()
              }
          } else {
            ReadableScrollView(currentPosition: $myLibraryVM.currentScrollPosition) {
                MyLibraryItemsScrollView(medias: getMyLibraryMedias())
            }
            .padding(.horizontal, Constants.paddingStandard)
          }

          VStack {
            MyLibraryTopBar()
            Spacer()
          }
        }
      }
    }

    // MARK: - Auxiliary functions

    private func getMyLibraryMedias() -> [SpotifyModel.MediaItem] {
      var myLibraryMedias = [SpotifyModel.MediaItem]()

      for section in MyLibraryViewModel.Section.allCases {
        // `tracksPreview` and `episodesPreview` data should not be loaded here
        if section != .userLikedSongs && section != .userSavedEpisodes {
          guard myLibraryVM.isLoading[section]! == false else { return [] }
          myLibraryMedias += myLibraryVM.mediaCollection[section]!
        }
      }

      return myLibraryMedias
    }

    private func didEverySectionLoaded() -> Bool {
      for key in myLibraryVM.isLoading.keys {

        // `tracksPreview` and `episodesPreview` will only be called if user
        // clicks liked songs item or my episodes item, so we can ignore it for now
        if key != .userLikedSongs && key != .userSavedEpisodes {
          // Now if any other section still loading, return false
          guard myLibraryVM.isLoading[key] != true else {
            return false
          }
        }
      }
      // else, return true
      return true
    }

  }

}
