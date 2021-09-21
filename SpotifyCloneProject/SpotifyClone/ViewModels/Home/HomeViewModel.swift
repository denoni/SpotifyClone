//
//  HomeViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

/// Because of API constraints, we can't have scrolls that fetch data progressively in all sections.
/// **Sections that support that:**
/// - Top Podcasts
/// - New Releases

import Foundation

class HomeViewModel: ObservableObject {
  var api = APIFetchingDataHomePage()
  var mainViewModel: MainViewModel
  @Published var isLoading = [String:Bool]()
  @Published var medias = [String:[SpotifyModel.MediaItem]]()
  @Published var numberOfLoadedItemsInSection = [String:Int]()


  init(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel

    // Populate isLoading and medias with all possible section keys
    for section in Section.allCases {
      isLoading[section.rawValue] = true
      medias[section.rawValue] = []
      numberOfLoadedItemsInSection[section.rawValue] = 0
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



  // MARK: - Calls to fetch data
  func getNewReleases(accessToken: String, loadingMore: Bool = false) {
    fetchDataFor(Section.newReleases, with: accessToken, loadingMore: loadingMore)
  }

  private func getTopPodcasts(accessToken: String) {
    fetchDataFor(Section.topPodcasts, with: accessToken)
  }

  private func getUserRecentlyPlayed(accessToken: String) {
    fetchDataFor(Section.recentlyPlayed, with: accessToken)
  }

  private func getUserFavoriteTracks(accessToken: String) {
    fetchDataFor(Section.userFavoriteTracks, with: accessToken)
  }

  // MARK: - Top Tracks From Artist
  private func getTopTracksFromArtist(accessToken: String, artistID: String) {

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




  func fetchDataFor(_ section: Section, with accessToken: String, loadingMore: Bool = false) {
    let sectionTitle = section.rawValue
    let numberOfItemsInEachLoad = 10
    let currentNumberOfLoadedItems = getNumberOfLoadedItems(for: section)
    increaseNumberOfLoadedItems(for: section, by: numberOfItemsInEachLoad)

    guard numberOfLoadedItemsInSection[section.rawValue]! <= 50 else {
      return
    }
    DispatchQueue.main.async {
      switch section {
      // MARK: - Recently Played
      case .recentlyPlayed:
        self.api.getUserRecentlyPlayed(accessToken: accessToken) { [unowned self] mediaItems in
          self.medias[sectionTitle] = mediaItems
          self.isLoading[sectionTitle] = false
        }

      // MARK: - User Favorite Tracks
      case .userFavoriteTracks:
        self.api.getUserFavoriteTracks(accessToken: accessToken) { [unowned self] mediaItems in
          self.medias[sectionTitle] = mediaItems
          self.isLoading[sectionTitle] = false
        }

      // MARK: - New Releases
      case .newReleases:
        if loadingMore {
          self.api.getNewReleases(accessToken: accessToken,
                                  limit: numberOfItemsInEachLoad,
                                  offset: currentNumberOfLoadedItems) { [unowned self] newItems in
            self.medias[section.rawValue]! += newItems

          }
        } else {
          self.api.getNewReleases(accessToken: accessToken) { [unowned self] mediaItems in
            self.medias[section.rawValue] = mediaItems
            self.isLoading[section.rawValue] = false

          }
        }

      // MARK: - Top Podcasts
      case .topPodcasts:
        if loadingMore {
          self.api.getTopPodcasts(accessToken: accessToken,
                                  limit: numberOfItemsInEachLoad,
                                  offset: currentNumberOfLoadedItems) { [unowned self] newItems in
            self.medias[section.rawValue]! += newItems
          }
        } else {
          self.api.getTopPodcasts(accessToken: accessToken) { [unowned self] mediaItems in
            self.medias[section.rawValue] = mediaItems
            self.isLoading[section.rawValue] = false

          }
        }
        
      default:
        fatalError("Tried to fetch data for a type not specified in the function declaration(fetchDataFor).")

      }
    }
  }



  func getNumberOfLoadedItems(for section: Section) -> Int {
    return numberOfLoadedItemsInSection[section.rawValue]!
  }

  func increaseNumberOfLoadedItems(for section: Section, by amount: Int) {
    if numberOfLoadedItemsInSection[section.rawValue]! <= 50 {
      numberOfLoadedItemsInSection[section.rawValue]! += amount
    }
  }

  
}
