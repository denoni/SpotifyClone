//
//  MyLibraryViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import Foundation

class MyLibraryViewModel: ObservableObject {
  var api = MyLibraryPageAPICalls()
  @Published var mainVM: MainViewModel

  @Published var isLoading = [Section:Bool]()
  @Published var mediaCollection = [Section:[SpotifyModel.MediaItem]]()

  enum Section: String, CaseIterable {
    case userPlaylists
    case userArtists
  }

  init(mainViewModel: MainViewModel) {
    self.mainVM = mainViewModel

    for section in Section.allCases {
      isLoading[section] = true
      mediaCollection[section] = []
    }

    fetchMyLibraryData()
  }

  func fetchMyLibraryData() {
    for dictKey in isLoading.keys { isLoading[dictKey] = true }

    if mainVM.authKey != nil {
      let accessToken = mainVM.authKey!.accessToken

      getCurrentUserPlaylists(accessToken: accessToken)
      getCurrentUserArtists(accessToken: accessToken)
    }
  }



  // MARK: - API Calls

  func getCurrentUserPlaylists(accessToken: String) {
    api.getCurrentUserPlaylists(with: accessToken) { playlists in
      self.trimAndCommunicateResult(section: .userPlaylists, medias: playlists)
    }
  }

  func getCurrentUserArtists(accessToken: String) {
    api.getCurrentUserArtists(with: accessToken) { artists in
      self.trimAndCommunicateResult(section: .userArtists, medias: artists)
    }
  }



  // MARK: - Auxiliary Functions

  func trimAndCommunicateResult(section: Section, medias: [SpotifyModel.MediaItem]) {
    var noDuplicateMedias = [SpotifyModel.MediaItem]()
    var mediaIDs = [String]()

    // Sometimes the API returns more than one item with the same id, so we need to delete duplicates.
    for media in medias {
      if !mediaIDs.contains(media.id) {
        mediaIDs.append(media.id)
        noDuplicateMedias.append(media)
      }
    }
    mediaCollection[section] = noDuplicateMedias

    isLoading[section] = false
  }

}
