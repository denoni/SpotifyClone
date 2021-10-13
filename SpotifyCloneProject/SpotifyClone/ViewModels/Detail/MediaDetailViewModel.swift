//
//  MediaDetailViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

// TODO: Simplify - Reduce duplicated code

import Foundation

class MediaDetailViewModel: ObservableObject {
  var api = MediaDetailsPageAPICalls()

  /// `mainItem` -  The item that was clicked to originate the current DetailView.
  var mainVM: MainViewModel
  @Published var mainItem: SpotifyModel.MediaItem?
  @Published var imageColorModel = RemoteImageModel(urlString: "")

  @Published var mediaCollection = [Section:[SpotifyModel.MediaItem]]()
  @Published var isLoading = [Section:Bool]()
  @Published var numberOfLoadedItemsInSection = [Section:Int]()
  @Published var accessToken: String?

  var detailScreenOrigin: DetailScreenOrigin? = nil

  enum DetailScreenOrigin {
    case home(homeVM: HomeViewModel)
    case search(searchVM: SearchViewModel)
  }

  init(mainVM: MainViewModel) {

    self.mainVM = mainVM

    // Artist
    for section in ArtistSections.allCases {
      isLoading[.artist(section)] = true
      mediaCollection[.artist(section)] = []
      numberOfLoadedItemsInSection[.artist(section)] = 0
    }

    // Playlist
    for section in PlaylistSections.allCases {
      isLoading[.playlist(section)] = true
      mediaCollection[.playlist(section)] = []
      numberOfLoadedItemsInSection[.playlist(section)] = 0
    }

    // Album
    for section in AlbumSections.allCases {
      isLoading[.album(section)] = true
      mediaCollection[.album(section)] = []
      numberOfLoadedItemsInSection[.album(section)] = 0
    }

    // Shows
    for section in ShowsSections.allCases {
      isLoading[.shows(section)] = true
      mediaCollection[.shows(section)] = []
      numberOfLoadedItemsInSection[.shows(section)] = 0
    }

    // Artist Basic Info
    for section in ArtistBasicInfo.allCases {
      isLoading[.artistBasicInfo(section)] = true
      mediaCollection[.artistBasicInfo(section)] = []
      numberOfLoadedItemsInSection[.artistBasicInfo(section)] = 0
    }

  }

  enum Section: Hashable {
    case artist(_ artistSection: ArtistSections)
    case playlist(_ playlistSection: PlaylistSections)
    case album(_ albumSection: AlbumSections)
    case shows(_ showSection: ShowsSections)
    case artistBasicInfo(_ basicSection: ArtistBasicInfo)
  }

  enum ArtistSections: CaseIterable {
    case topTracksFromArtist
    case albumsFromArtist
    case playlistsFromArtist
  }

  enum PlaylistSections: CaseIterable {
    case tracksFromPlaylist
  }

  enum AlbumSections: CaseIterable {
    case tracksFromAlbum
  }

  enum ShowsSections: CaseIterable {
    case episodesFromShow
  }

  enum ArtistBasicInfo: CaseIterable {
    case artistBasicInfo
  }

  func getArtistScreenData() {
    ArtistAPICalls.getTopTracksFromArtist(mediaVM: self)
    ArtistAPICalls.getAlbumsFromArtist(mediaVM: self)
    ArtistAPICalls.getPlaylistFromArtist(mediaVM: self)
  }

  func getPlaylistScreenData() {
    PlaylistAPICalls.getTracksFromPlaylist(mediaVM: self)
  }

  func getAlbumScreenData() {
    PlaylistAPICalls.getTracksFromPlaylist(mediaVM: self)
  }

  func getShowsScreenData() {
    ShowsAPICalls.getEpisodesFromShows(mediaVM: self)
  }


  struct ArtistAPICalls {

    static func getTopTracksFromArtist(mediaVM: MediaDetailViewModel) {
      mediaVM.api.getTopTracksFromArtist(with: mediaVM.accessToken!, artistID: mediaVM.mainItem!.id) { tracks in
        mediaVM.trimAndCommunicateResult(medias: tracks, section: .artist(.topTracksFromArtist), limit: 5)
      }
    }

    static func getAlbumsFromArtist(mediaVM: MediaDetailViewModel) {
      mediaVM.api.getAlbumsFromArtist(with: mediaVM.accessToken!, artistID: mediaVM.mainItem!.id) { albums in
        mediaVM.trimAndCommunicateResult(medias: albums, section: .artist(.albumsFromArtist), limit: 5)
      }
    }

    static func getPlaylistFromArtist(mediaVM: MediaDetailViewModel) {
      // Remote special characters artist title(name)
      let keyWord: String = mediaVM.mainItem!.title.folding(options: .diacriticInsensitive, locale: .current)

      mediaVM.api.getPlaylistsFromArtist(with: mediaVM.accessToken!, keyWord: keyWord) { playlists in
        mediaVM.trimAndCommunicateResult(medias: playlists, section: .artist(.playlistsFromArtist))
      }
    }

  }


  struct PlaylistAPICalls {

    static func getTracksFromPlaylist(mediaVM: MediaDetailViewModel,
                                      loadMoreEnabled: Bool = false) {
      let offset = mediaVM.getNumberOfLoadedItems(for: .playlist(.tracksFromPlaylist))
      mediaVM.increaseNumberOfLoadedItems(for: .playlist(.tracksFromPlaylist), by: 10)

      mediaVM.api.getTracksFromPlaylist(with: mediaVM.accessToken!,
                                        playlistID: SpotifyModel.getPlaylistDetails(for: mediaVM.mainItem!).id,
                                        offset: offset) { tracks in

        mediaVM.trimAndCommunicateResult(medias: tracks, section: .playlist(.tracksFromPlaylist), loadMoreEnabled: loadMoreEnabled)
      }
    }

  }


  struct AlbumAPICalls {

    static func getTracksFromAlbum(mediaVM: MediaDetailViewModel,
                                   loadMoreEnabled: Bool = false) {
      let offset = mediaVM.getNumberOfLoadedItems(for: .album(.tracksFromAlbum))
      mediaVM.increaseNumberOfLoadedItems(for: .album(.tracksFromAlbum), by: 10)

      mediaVM.api.getTracksFromAlbum(with: mediaVM.accessToken!,
                                     albumID: SpotifyModel.getAlbumDetails(for: mediaVM.mainItem!).id,
                                     offset: offset) { tracks in
        mediaVM.trimAndCommunicateResult(medias: tracks, section: .album(.tracksFromAlbum),
                                         loadMoreEnabled: loadMoreEnabled)
      }
    }

  }


  struct ShowsAPICalls {

    static func getEpisodesFromShows(mediaVM: MediaDetailViewModel,
                                     loadMoreEnabled: Bool = false) {
      let offset = mediaVM.getNumberOfLoadedItems(for: .shows(.episodesFromShow))
      mediaVM.increaseNumberOfLoadedItems(for: .shows(.episodesFromShow), by: 10)

      mediaVM.api.getEpisodesFromShow(with: mediaVM.accessToken!,
                                     showID: SpotifyModel.getShowDetails(for: mediaVM.mainItem!).id,
                                     offset: offset) { episodes in
        mediaVM.trimAndCommunicateResult(medias: episodes, section: .shows(.episodesFromShow),
                                         loadMoreEnabled: loadMoreEnabled)
      }
    }

  }

  // Gets the artist basic info(followers, popularity, profile image -> we're mainly interested in the image)
  func getArtistBasicInfo(mediaVM: MediaDetailViewModel) {
    var artistIDs = [String]()
    for index in mediaVM.mainItem!.author!.indices {
      artistIDs.append(mediaVM.mainItem!.author![index].id)
    }
    
    mediaVM.api.basicInfoAPI.getArtists(with: mediaVM.accessToken!, artistIDs: artistIDs) { artists in
      mediaVM.trimAndCommunicateResult(medias: artists, section: .artistBasicInfo(.artistBasicInfo))
    }
  }




  // MARK: - API Auxiliary Functions

  func trimAndCommunicateResult(medias: [SpotifyModel.MediaItem],
                                section: Section,
                                limit: Int = 10,
                                loadMoreEnabled: Bool = false,
                                deleteAlmostDuplicateResults: Bool = false) {

    let noDuplicateMedias = getNonDuplicateItems(for: medias,
                                                 deleteAlmostDuplicateResults: deleteAlmostDuplicateResults)

    // If the api got more than `limit` items, return just the elements within the `limit`
    let mediasWithinTheLimit = noDuplicateMedias.count >= limit ? Array(noDuplicateMedias.prefix(limit)) : noDuplicateMedias


    if loadMoreEnabled {
      mediaCollection[section]! += noDuplicateMedias
    } else {
      mediaCollection[section] = mediasWithinTheLimit
    }


    isLoading[section] = false
  }

  func getNumberOfLoadedItems(for section: Section) -> Int {
    return numberOfLoadedItemsInSection[section]!
  }

  func increaseNumberOfLoadedItems(for section: Section, by amount: Int) {
    numberOfLoadedItemsInSection[section]! += amount
  }

  // If we are reaching the end of the scroll, fetch more data
  func shouldFetchMoreData(basedOn media: SpotifyModel.MediaItem,
                                 inRelationTo medias: [SpotifyModel.MediaItem]) -> Bool {
    if medias.count > 5 {
      if media.id == medias[medias.count - 4].id {
        return true
      }
    }
    return false
  }



  // MARK: - Non-API Auxiliary Functions

  func clean() {
    mainItem = nil

    for section in ArtistSections.allCases {
      isLoading[.artist(section)] = true
      mediaCollection[.artist(section)]! = []
      numberOfLoadedItemsInSection[.artist(section)] = 0
    }
    for section in PlaylistSections.allCases {
      isLoading[.playlist(section)] = true
      mediaCollection[.playlist(section)]! = []
      numberOfLoadedItemsInSection[.playlist(section)] = 0
    }
    for section in AlbumSections.allCases {
      isLoading[.album(section)] = true
      mediaCollection[.album(section)]! = []
      numberOfLoadedItemsInSection[.album(section)] = 0
    }
    for section in ShowsSections.allCases {
      isLoading[.shows(section)] = true
      mediaCollection[.shows(section)]! = []
      numberOfLoadedItemsInSection[.shows(section)] = 0
    }
  }

  func setVeryFirstImageInfoBasedOn(_ firstImageURL: String) {
    imageColorModel = RemoteImageModel(urlString: firstImageURL)
  }

  func returnBasicArtistsInfo() -> [SpotifyModel.MediaItem] {
    return mediaCollection[.artistBasicInfo(.artistBasicInfo)]!
  }

  private func getNonDuplicateItems(for medias: [SpotifyModel.MediaItem],
                                    deleteAlmostDuplicateResults: Bool = false) -> [SpotifyModel.MediaItem] {
    var trimmedMedias = [SpotifyModel.MediaItem]()
    var noDuplicateMedias = [SpotifyModel.MediaItem]()

    // Why we check for duplicate items? -
    //  Some API results are exactly the same(same id) which causes crashes

    // Why to use `deleteAlmostDuplicateResults`?
    //  to avoid results like: ["Album Name","Album Name (Radio)"], we delete those almost duplicate items.

    if !deleteAlmostDuplicateResults {
      var mediaIDs = [String]()

      for media in medias {
        if !mediaIDs.contains(media.id) {
          mediaIDs.append(media.id)
          noDuplicateMedias.append(media)
        }
      }
    } else {

      for media in medias {
        var trimmedMedia = media

        if media.title.contains("(") {
          let firstOccurrenceBraces = media.title.firstIndex(of: "(")!
          let lastIndex = media.title.endIndex

          // Remove everything after the first "("
          trimmedMedia.title.removeSubrange(firstOccurrenceBraces ..< lastIndex)
          // Remove the " " ("Album Name " -> "Album Name")
          if trimmedMedia.title.last == " " {
            trimmedMedia.title.removeLast()
          }
        }
        trimmedMedias.append(trimmedMedia)
      }

      var noDuplicateMedias = [SpotifyModel.MediaItem]()

      for media in trimmedMedias {
        var containsDuplicate = false

        if noDuplicateMedias.isEmpty {
          noDuplicateMedias.append(media)
        } else {
          for noDuplicateMedia in noDuplicateMedias {
            // .lowercased to compare only the letters, ignoring upper/lower case
            if media.title.lowercased() == noDuplicateMedia.title.lowercased() {
              containsDuplicate = true
            }
          }
          if !containsDuplicate { noDuplicateMedias.append(media) }
        }
      }

    }


    return noDuplicateMedias
  }

}
