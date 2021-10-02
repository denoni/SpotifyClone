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
/// - Playlist This is X

// TODO: Separate api related and non-api related into different files
// TODO: Access Control

import SwiftUI

class HomeViewModel: ObservableObject {
  var api = HomePageAPICalls()
  @Published var mainVM: MainViewModel
  
  @Published var isLoading = [Section:Bool]()
  @Published var mediaCollection = [Section:[SpotifyModel.MediaItem]]()
  @Published var numberOfLoadedItemsInSection = [Section:Int]()
  
  @Published var currentSubPage: HomeSubpage = .none
  
  @Published var veryFirstImageInfo = RemoteImageModel(urlString: "")
  
  enum HomeSubpage {
    case none
    case playlistDetail
    case trackDetail
    case albumDetail
    case showDetail
    case artistDetail
  }
  
  init(mainViewModel: MainViewModel) {
    self.mainVM = mainViewModel
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
    case playlistThisIsX = "This Is..."
    case playlistRewind90s = "Rewind to the 90s"
    case playlistRewind80s = "Rewind the 80s"
    case playlistRewind70s = "Rewind the 70s"
    case playlistRewind2000s = "2000s Rewind"
    case playlistRewind2010s = "2010s Rewind"
  }
  
  func fetchHomeData() {
    for dictKey in isLoading.keys { isLoading[dictKey] = true }
    
    if mainVM.authKey != nil {
      let accessToken = mainVM.authKey!.accessToken
      
      getSmallSongCardItems(accessToken: accessToken)
      getUserFavoriteTracks(accessToken: accessToken)
      getUserRecentlyPlayed(accessToken: accessToken)
      getNewReleases(accessToken: accessToken)
      getTopPodcasts(accessToken: accessToken)
      getTopTracksFromArtist(accessToken: accessToken)
      getFeaturedPlaylists(accessToken: accessToken)
      getUserFavoriteArtists(accessToken: accessToken)
      getPlaylistYearRewinds(accessToken: accessToken, year: .playlistRewind2010s)
      getPlaylistYearRewinds(accessToken: accessToken, year: .playlistRewind2000s)
      getPlaylistYearRewinds(accessToken: accessToken, year: .playlistRewind90s)
      getPlaylistYearRewinds(accessToken: accessToken, year: .playlistRewind80s)
      getPlaylistYearRewinds(accessToken: accessToken, year: .playlistRewind70s)
      getPlaylistThisIsX(accessToken: accessToken)
    }
  }
  
  
  
  // MARK: - Calls to fetch data
  
  private func getSmallSongCardItems(accessToken: String, loadingMore: Bool = false) {
    fetchDataFor(Section.smallSongCards, with: accessToken)
  }
  
  private func getNewReleases(accessToken: String, loadingMore: Bool = false) {
    fetchDataFor(Section.newReleases, with: accessToken)
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
  
  private func getPlaylistYearRewinds(accessToken: String, year: Section) {
    fetchDataFor(year, with: accessToken)
  }
  
  private func getPlaylistThisIsX(accessToken: String) {
    fetchDataFor(Section.playlistThisIsX, with: accessToken)
  }
  
  private func getTopTracksFromArtist(accessToken: String) {
    fetchDataFor(Section.artistTopTracks, with: accessToken)
  }
  
  
  
  // MARK: - Fetch Data From API
  
  func fetchDataFor(_ section: Section, with accessToken: String) {
    let numberOfItemsInEachLoad = 10
    let currentNumberOfLoadedItems = getNumberOfLoadedItems(for: section)
    increaseNumberOfLoadedItems(for: section, by: numberOfItemsInEachLoad)
    
    guard numberOfLoadedItemsInSection[section]! <= 50 else {
      return
    }
    
    DispatchQueue.main.async { [unowned self] in
      switch section {
      
      // MARK: - Track Responses
      
      // MARK: Small Song Card Items
      case .smallSongCards:
        api.getTrack(using: .userFavoriteTracks, with: accessToken) { tracks in
          trimAndCommunicateResult(section: section, medias: tracks)
          setVeryFirstImageInfoBasedOn(tracks[0].imageURL)
        }
        
      // MARK: Recently Played
      case .recentlyPlayed:
        api.getTrack(using: .userRecentlyPlayed, with: accessToken) { tracks in
          trimAndCommunicateResult(section: section, medias: tracks)
        }
        
      // MARK: User Favorite Tracks
      case .userFavoriteTracks:
        api.getTrack(using: .userFavoriteTracks,
                     with: accessToken,
                     limit: numberOfItemsInEachLoad,
                     offset: currentNumberOfLoadedItems) { tracks in
          trimAndCommunicateResult(section: section, medias: tracks, loadMoreEnabled: true)
        }
        
        
      // MARK: - Artist Responses
      
      // MARK: User Favorite Artists
      case .userFavoriteArtists:
        api.getArtist(using: .userFavoriteArtists, with: accessToken) { artists in
          trimAndCommunicateResult(section: section, medias: artists)
        }
        
      // MARK: New Releases
      case .newReleases:
        api.getAlbum(using: .newReleases,
                     with: accessToken,
                     limit: numberOfItemsInEachLoad,
                     offset: currentNumberOfLoadedItems) { albums in
          trimAndCommunicateResult(section: section, medias: albums, loadMoreEnabled: true)
        }
        
      // MARK: Top Podcasts
      case .topPodcasts:
        api.getShow(using: .topPodcasts,
                    with: accessToken,
                    limit: numberOfItemsInEachLoad,
                    offset: currentNumberOfLoadedItems) { podcasts in
          trimAndCommunicateResult(section: section, medias: podcasts, loadMoreEnabled: true)
        }
        
      // MARK: Featured Playlists
      case .featuredPlaylists:
        api.getPlaylist(using: .featuredPlaylists, with: accessToken, limit: 20) { playlists in
          trimAndCommunicateResult(section: section, medias: playlists)
        }
        
      // MARK: Playlist This is X
      case .playlistThisIsX:
        let keyWord = "this is"
        api.getPlaylist(using: .playlistWithKeyword(keyWord: keyWord),
                        with: accessToken,
                        limit: numberOfItemsInEachLoad,
                        offset: currentNumberOfLoadedItems) { playlists in
          trimAndCommunicateResult(section: section, medias: playlists, loadMoreEnabled: true)
        }
        
      // MARK: Playlist Year Rewinds
      case .playlistRewind2010s, .playlistRewind2000s, .playlistRewind90s,
           .playlistRewind80s, .playlistRewind70s :
        
        var keyWord = "top hits of "
        switch section {
        case .playlistRewind2010s:
          keyWord += "201_"
        case .playlistRewind2000s:
          keyWord += "200_"
        case .playlistRewind90s:
          keyWord += "199_"
        case .playlistRewind80s:
          keyWord += "198_"
        case .playlistRewind70s:
          keyWord += "197_"
        default:
          fatalError("Year not defined or the section is not a year.")
        }
        
        api.getPlaylist(using: .playlistWithKeyword(keyWord: keyWord), with: accessToken) { playlists in
          trimAndCommunicateResult(section: section, medias: playlists)
        }
        
      // MARK: Artist's Top Tracks
      case .artistTopTracks:
        var artistID = ""
        // Get the user's most favorite artist
        api.getArtist(using: .userFavoriteArtists, with: accessToken) { artists in
          let userMostFavoriteArtist = artists[0]
          artistID = userMostFavoriteArtist.id
          mediaCollection[section]!.insert(artists[0], at: 0)
          
          // Add the artist's top songs
          api.getTrack(using: .topTracksFromArtist(artistID: artistID), with: accessToken) { tracks in
            trimAndCommunicateResult(section: section, medias: tracks, loadMoreEnabled: true)
          }
        }
      default:
        fatalError("Tried to fetch data for a type not specified in the function declaration(fetchDataFor).")
        
      }
    }
  }
  
  
  
  // MARK: - Auxiliary Functions
  
  func getNumberOfLoadedItems(for section: Section) -> Int {
    return numberOfLoadedItemsInSection[section]!
  }
  
  func increaseNumberOfLoadedItems(for section: Section, by amount: Int) {
    if numberOfLoadedItemsInSection[section]! <= 50 {
      numberOfLoadedItemsInSection[section]! += amount
    }
  }
  
  func trimAndCommunicateResult(section: Section, medias: [SpotifyModel.MediaItem], loadMoreEnabled: Bool = false) {
    var noDuplicateMedias = [SpotifyModel.MediaItem]()
    var mediaIDs = [String]()
    
    for media in medias {
      if !mediaIDs.contains(media.id) {
        mediaIDs.append(media.id)
        noDuplicateMedias.append(media)
      }
    }
    
    if loadMoreEnabled {
      mediaCollection[section]! += noDuplicateMedias
    } else {
      mediaCollection[section] = noDuplicateMedias
    }
    
    isLoading[section] = false
  }
  
  
  // MARK: - Non-api Related Functions
  
  func goToNoneSubpage( ) {
    currentSubPage = .none
  }
  
  func changeSubpageTo(_ subPage: HomeSubpage,
                       mediaDetailVM: MediaDetailViewModel,
                       withData data: SpotifyModel.MediaItem) {
    mediaDetailVM.clean()
    mediaDetailVM.mainItem = data
    mediaDetailVM.accessToken = mainVM.authKey!.accessToken
    mediaDetailVM.setVeryFirstImageInfoBasedOn(data.imageURL)
    currentSubPage = subPage
  }
  
  func setVeryFirstImageInfoBasedOn(_ firstImageURL: String) {
    veryFirstImageInfo = RemoteImageModel(urlString: firstImageURL)
  }
  
}
