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
  @Published var isLoading = [Section:Bool]()
  @Published var mediaCollection = [Section:[SpotifyModel.MediaItem]]()
  @Published var numberOfLoadedItemsInSection = [Section:Int]()


  init(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel

    // Populate isLoading and medias with all possible section keys
    for section in Section.allCases {
      isLoading[section] = true
      mediaCollection[section] = []
      numberOfLoadedItemsInSection[section] = 0
    }
    fetchHomeData()
  }

  enum Section: String, CaseIterable {
    case userFavoriteTracks = "Small Song Card Items"
    case userFavoriteArtists = "Your Artists"
    case recentlyPlayed = "Recently Played"
    case newReleases = "New Releases"
    case topPodcasts = "Top Podcasts"
    case artistTopTracks = "Artist Top Tracks"
    case featuredPlaylists = "Featured Playlists"
  }

  func fetchHomeData() {
    for dictKey in isLoading.keys { isLoading[dictKey] = true }

    if mainViewModel.authKey != nil {

      let accessToken = mainViewModel.authKey!.accessToken

      getUserFavoriteTracks(accessToken: accessToken)
      getUserRecentlyPlayed(accessToken: accessToken)
      getNewReleases(accessToken: accessToken)
      getTopPodcasts(accessToken: accessToken)
      getTopTracksFromArtist(accessToken: accessToken)
      getFeaturedPlaylists(accessToken: accessToken)
      getUserFavoriteArtists(accessToken: accessToken)
    }
  }



  // MARK: - Calls to fetch data
  private func getNewReleases(accessToken: String, loadingMore: Bool = false) {
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

  private func getUserFavoriteArtists(accessToken: String) {
    fetchDataFor(Section.userFavoriteArtists, with: accessToken)
  }

  private func getFeaturedPlaylists(accessToken: String) {
    fetchDataFor(Section.featuredPlaylists, with: accessToken)
  }

  // MARK: - Top Tracks From Artist
  private func getTopTracksFromArtist(accessToken: String) {
    fetchDataFor(Section.artistTopTracks, with: accessToken)
  }




  func fetchDataFor(_ section: Section, with accessToken: String, loadingMore: Bool = false) {
    let numberOfItemsInEachLoad = 10
    let currentNumberOfLoadedItems = getNumberOfLoadedItems(for: section)
    increaseNumberOfLoadedItems(for: section, by: numberOfItemsInEachLoad)

    guard numberOfLoadedItemsInSection[section]! <= 50 else {
      return
    }
    DispatchQueue.main.async {
      switch section {
      // MARK: - Recently Played
      case .recentlyPlayed:
        self.api.getUserRecentlyPlayed(accessToken: accessToken) { [unowned self] medias in
          self.mediaCollection[section] = medias
          self.isLoading[section] = false
        }

      // MARK: - User Favorite Tracks
      case .userFavoriteTracks:
        self.api.getUserFavoriteTracks(accessToken: accessToken) { [unowned self] medias in
          self.mediaCollection[section] = medias
          self.isLoading[section] = false
        }

      // MARK: - User Favorite Artists
      case .userFavoriteArtists:
        self.api.getUserFavoriteArtists(accessToken: accessToken) { [unowned self] artists in
          self.mediaCollection[section] = artists
          self.isLoading[section] = false
        }

      // MARK: - New Releases
      case .newReleases:
        if loadingMore {
          self.api.getNewReleases(accessToken: accessToken,
                                  limit: numberOfItemsInEachLoad,
                                  offset: currentNumberOfLoadedItems) { [unowned self] tracks in
            self.mediaCollection[section]! += tracks

          }
        } else {
          self.api.getNewReleases(accessToken: accessToken) { [unowned self] tracks in
            self.mediaCollection[section] = tracks
            self.isLoading[section] = false

          }
        }

      // MARK: - Top Podcasts
      case .topPodcasts:
        if loadingMore {
          self.api.getTopPodcasts(accessToken: accessToken,
                                  limit: numberOfItemsInEachLoad,
                                  offset: currentNumberOfLoadedItems) { [unowned self] podcasts in
            self.mediaCollection[section]! += podcasts
          }
        } else {
          self.api.getTopPodcasts(accessToken: accessToken) { [unowned self] podcasts in
            self.mediaCollection[section] = podcasts
            self.isLoading[section] = false

          }
        }

      // MARK: - Featured Playlists
      case .featuredPlaylists:
          self.api.getPlaylists(accessToken: accessToken) { [unowned self] playlists in
            self.mediaCollection[section] = playlists
            self.isLoading[section] = false
          }

      // MARK: - Artist's Top Tracks
      case .artistTopTracks:

        var artistID = ""

        self.api.getUserFavoriteArtists(accessToken: accessToken) { artists in
          let userMostFavoriteArtist = artists[0]
          artistID = userMostFavoriteArtist.id

          print("executed")

          // Insert the artist info in the first element
          self.api.getArtist(accessToken: accessToken, artistID: artistID) { [unowned self] artist in
            mediaCollection[section]!.insert(contentsOf: artist, at: 0)
          }

          // Add the artist's top songs
          self.api.getTopTracksFromArtist(accessToken: accessToken,
                                          country: "US",
                                          id: artistID) { [unowned self] trackItems in
            mediaCollection[section]!.append(contentsOf: trackItems)
            isLoading[section] = false
          }
        }        
      default:
        fatalError("Tried to fetch data for a type not specified in the function declaration(fetchDataFor).")

      }
    }
  }



  // MARK: - Auxiliary functions

  func getNumberOfLoadedItems(for section: Section) -> Int {
    return numberOfLoadedItemsInSection[section]!
  }

  func increaseNumberOfLoadedItems(for section: Section, by amount: Int) {
    if numberOfLoadedItemsInSection[section]! <= 50 {
      numberOfLoadedItemsInSection[section]! += amount
    }
  }

  
}
