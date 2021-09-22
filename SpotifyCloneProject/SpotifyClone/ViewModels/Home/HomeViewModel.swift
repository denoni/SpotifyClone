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
    case smallSongCards = "Small Song Card Items"
    case userFavoriteTracks = "Songs You Love"
    case userFavoriteArtists = "Your Artists"
    case recentlyPlayed = "Recently Played"
    case newReleases = "New Releases"
    case topPodcasts = "Top Podcasts"
    case artistTopTracks = "Artist Top Tracks"
    case featuredPlaylists = "Featured Playlists"
    case playlistTopHits = "Top Hits"
    case playlistThisIsX = "This Is..."
  }

  func fetchHomeData() {
    for dictKey in isLoading.keys { isLoading[dictKey] = true }

    if mainViewModel.authKey != nil {

      let accessToken = mainViewModel.authKey!.accessToken

      getSmallSongCardItems(accessToken: accessToken)
      getUserFavoriteTracks(accessToken: accessToken)
      getUserRecentlyPlayed(accessToken: accessToken)
      getNewReleases(accessToken: accessToken)
      getTopPodcasts(accessToken: accessToken)
      getTopTracksFromArtist(accessToken: accessToken)
      getFeaturedPlaylists(accessToken: accessToken)
      getUserFavoriteArtists(accessToken: accessToken)
      getPlaylistTopHits(accessToken: accessToken)
      getPlaylistThisIsX(accessToken: accessToken)
    }
  }



  // MARK: - Calls to fetch data

  private func getSmallSongCardItems(accessToken: String, loadingMore: Bool = false) {
    fetchDataFor(Section.smallSongCards, with: accessToken, loadingMore: loadingMore)
  }

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

  private func getPlaylistTopHits(accessToken: String) {
    fetchDataFor(Section.playlistTopHits, with: accessToken)
  }

  private func getPlaylistThisIsX(accessToken: String) {
    fetchDataFor(Section.playlistThisIsX, with: accessToken)
  }

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
    DispatchQueue.main.async { [unowned self] in
      switch section {
      // MARK: - Small Song Card Items
      case .smallSongCards:
        api.getUserFavoriteTracks(accessToken: accessToken) { tracks in
          mediaCollection[section] = tracks
          isLoading[section] = false
        }

      // MARK: - Recently Played
      case .recentlyPlayed:
        api.getUserRecentlyPlayed(accessToken: accessToken) { medias in
          mediaCollection[section] = medias
          isLoading[section] = false
        }

      // MARK: - User Favorite Tracks
      case .userFavoriteTracks:
        if loadingMore {
          api.getUserFavoriteTracks(accessToken: accessToken,
                                  limit: numberOfItemsInEachLoad,
                                  offset: currentNumberOfLoadedItems) { tracks in
            mediaCollection[section]! += tracks
          }
        } else {
          api.getUserFavoriteTracks(accessToken: accessToken) { tracks in
            mediaCollection[section] = tracks
            isLoading[section] = false

          }
        }

      // MARK: - User Favorite Artists
      case .userFavoriteArtists:
        api.getUserFavoriteArtists(accessToken: accessToken) { artists in
          mediaCollection[section] = artists
          isLoading[section] = false
        }

      // MARK: - New Releases
      case .newReleases:
        if loadingMore {
          api.getNewReleases(accessToken: accessToken,
                                  limit: numberOfItemsInEachLoad,
                                  offset: currentNumberOfLoadedItems) { tracks in
            mediaCollection[section]! += tracks

          }
        } else {
          api.getNewReleases(accessToken: accessToken) { tracks in
            mediaCollection[section] = tracks
            isLoading[section] = false

          }
        }

      // MARK: - Top Podcasts
      case .topPodcasts:
        if loadingMore {
          api.getTopPodcasts(accessToken: accessToken,
                                  limit: numberOfItemsInEachLoad,
                                  offset: currentNumberOfLoadedItems) { podcasts in
            mediaCollection[section]! += podcasts
          }
        } else {
          api.getTopPodcasts(accessToken: accessToken) { podcasts in
            mediaCollection[section] = podcasts
            isLoading[section] = false

          }
        }

      // MARK: - Featured Playlists
      case .featuredPlaylists:
          api.getFeaturedPlaylists(accessToken: accessToken) { playlists in
            mediaCollection[section] = playlists
            isLoading[section] = false
          }

      // MARK: - Playlist Top Hits
      case .playlistTopHits:
        let keyWord = "top hits"
        if loadingMore {
          api.getPlaylistsWith(keyWord: keyWord, accessToken: accessToken,
                                  limit: numberOfItemsInEachLoad,
                                  offset: currentNumberOfLoadedItems) { podcasts in
            mediaCollection[section]! += podcasts
          }
        } else {
          api.getPlaylistsWith(keyWord: keyWord, accessToken: accessToken) { podcasts in
            mediaCollection[section] = podcasts
            isLoading[section] = false

          }
        }

      // MARK: - Playlist Year Rewinds
      case .playlistThisIsX:
        let keyWord = "this is"
        if loadingMore {
          api.getPlaylistsWith(keyWord: keyWord, accessToken: accessToken,
                                  limit: numberOfItemsInEachLoad,
                                  offset: currentNumberOfLoadedItems) { podcasts in
            mediaCollection[section]! += podcasts
          }
        } else {
          api.getPlaylistsWith(keyWord: keyWord, accessToken: accessToken) { podcasts in
            mediaCollection[section] = podcasts
            isLoading[section] = false

          }
        }

      // MARK: - Artist's Top Tracks
      case .artistTopTracks:

        var artistID = ""

        // Get the user's most favorite artist
        api.getUserFavoriteArtists(accessToken: accessToken) { artists in
          let userMostFavoriteArtist = artists[0]
          artistID = userMostFavoriteArtist.id

          // Insert the artist info in the first element
          api.getArtist(accessToken: accessToken, artistID: artistID) { artist in
            mediaCollection[section]!.insert(contentsOf: artist, at: 0)
          }

          // Add the artist's top songs
          api.getTopTracksFromArtist(accessToken: accessToken,
                                          country: "US",
                                          id: artistID) { trackItems in
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
