//
//  HomeViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import SwiftUI

class HomeViewModel: ObservableObject {
  @ObservedObject var api = APIFetchingData()
  @Published var mainViewModel: MainViewModel
  @Published var isLoading = [String:Bool]()

  @Published var medias = [String:[SpotifyModel.MediaItem]]()


  init(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel

    // Populate isLoading and medias with all possible section keys
    for section in Section.allCases {
      print(" >>> \(section)")
      isLoading[section.rawValue] = true
      medias[section.rawValue] = []
    }
    fetchHomeData()
  }

  enum Section: String, CaseIterable {
    case userFavoriteTracks = "Small Song Card Items"
    case recentlyPlayed = "Recently Played"
    case newReleases = "New Releases"
    case topPodcasts = "Top Podcasts"
    case artistTopTracks = "Artist Top Tracks"
  }

  // Load data dynamically to show the homeScreen faster
  func fetchHomeData() {
    for key in isLoading.keys { isLoading[key] = true }

    if mainViewModel.authKey != nil {
      getUserFavoriteTracks(accessToken: mainViewModel.authKey!.accessToken)
      getUserRecentlyPlayed(accessToken: mainViewModel.authKey!.accessToken)
      getNewReleases(accessToken: mainViewModel.authKey!.accessToken)
      getTopPodcasts(accessToken: mainViewModel.authKey!.accessToken)
      getTopTracksFromArtist(accessToken: mainViewModel.authKey!.accessToken,
                             artistID: "66CXWjxzNUsdJxJ2JdwvnR" /* arianaGrandeID */)
    }
  }

  func getTopTracksFromArtist(accessToken: String, artistID: String) {

    let sectionTitle = Section.artistTopTracks.rawValue

    DispatchQueue.main.async {
      // Insert the artist info in the first element
      self.api.getArtist(accessToken: accessToken, artistID: artistID) { artist in
        self.medias[sectionTitle]!.insert(contentsOf: artist, at: 0)
      }

      // Add the artist's top songs
      self.api.getTopTracksFromArtist(accessToken: accessToken,
                                      country: "US",
                                      id: artistID) { [unowned self] trackItems in
        self.medias[sectionTitle]!.append(contentsOf: trackItems)
        self.isLoading[sectionTitle] = false
      }
    }
  }

  func getNewReleases(accessToken: String) {
    fetchDataFor(Section.newReleases, with: accessToken)
  }

  func getTopPodcasts(accessToken: String) {
    fetchDataFor(Section.topPodcasts, with: accessToken)
  }

  func getUserRecentlyPlayed(accessToken: String) {
    fetchDataFor(Section.recentlyPlayed, with: accessToken)
  }

  func getUserFavoriteTracks(accessToken: String) {
    fetchDataFor(Section.userFavoriteTracks, with: accessToken)
  }

  

  func fetchDataFor(_ section: Section, with accessToken: String) {
    let sectionTitle = section.rawValue


    DispatchQueue.main.async {
      switch section {
      case .newReleases:
        self.api.getNewReleases(accessToken: accessToken) { [unowned self] mediaItems in
          print("\(mediaItems)")
          self.medias[sectionTitle] = mediaItems
          self.isLoading[sectionTitle] = false
        }
      case .recentlyPlayed:
        self.api.getUserRecentlyPlayed(accessToken: accessToken) { [unowned self] mediaItems in
          self.medias[sectionTitle] = mediaItems
          self.isLoading[sectionTitle] = false
        }
      case .userFavoriteTracks:
        self.api.getUserFavoriteTracks(accessToken: accessToken) { [unowned self] mediaItems in
          self.medias[sectionTitle] = mediaItems
          self.isLoading[sectionTitle] = false
        }
      case .topPodcasts:
        self.api.getTopPodcasts(accessToken: accessToken) { [unowned self] mediaItems in
          self.medias[sectionTitle] = mediaItems
          self.isLoading[sectionTitle] = false
        }
      default:
        fatalError("Tried to fetch data for a type not specified in the function declaration(fetchDataFor).")
      }
    }
  }
  
}
