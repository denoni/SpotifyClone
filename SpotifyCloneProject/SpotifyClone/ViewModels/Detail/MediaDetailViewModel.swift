//
//  MediaDetailViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

protocol MediaDetailSectionsProtocol {}

class MediaDetailViewModel: ObservableObject {
  private(set) var api = MediaDetailsPageAPICalls()
  var mainVM: MainViewModel

  // The item that was clicked to originate the current DetailView.
  @Published var mainItem: SpotifyModel.MediaItem?
  @Published private(set) var imageColorModel = RemoteImageModel(urlString: "")

  @Published private(set) var mediaCollection = [MediaDetailSection: [SpotifyModel.MediaItem]]()
  @Published private(set) var isLoading = [MediaDetailSection: Bool]()
  @Published private(set) var numberOfLoadedItemsInSection = [MediaDetailSection: Int]()
  @Published var accessToken: String?

  var detailScreenOrigin: DetailScreenOrigin?
  @Published var followedIDs = [String: CurrentFollowingState]()
  @Published var userLibraryInfo = [UserLibraryInfoSections: Int?]()

  enum UserLibraryInfoSections: CaseIterable {
    case numberOfLikedSongs
    case numberOfSavedEpisodes
  }

  enum CurrentFollowingState {
    case isFollowing
    case isNotFollowing
    case error
  }

  enum DetailScreenOrigin {
    case home(homeVM: HomeViewModel)
    case search(searchVM: SearchViewModel)
    case myLibrary(myLibraryVM: MyLibraryViewModel)
  }

  enum BasicDetailSubpages {
    case playlistDetail
    case trackDetail
    case albumDetail
    case showDetail
    case artistDetail
    case episodeDetail
  }

  init(mainVM: MainViewModel) {
    self.mainVM = mainVM
    cleanAllSection()
  }

  func deleteImageFromCache(imageURL: String) {
    ImageCache.deleteImageFromCache(imageURL: imageURL)
    self.objectWillChange.send()
  }

  func getArtistScreenData() {
    MediaDetailAPICalls.UserInfoAPICalls.checksIfUserFollows(.artist, mediaDetailVM: self, itemID: self.mainItem!.id)
    MediaDetailAPICalls.ArtistAPICalls.getTopTracksFromArtist(mediaDetailVM: self)
    MediaDetailAPICalls.ArtistAPICalls.getAlbumsFromArtist(mediaDetailVM: self)
    MediaDetailAPICalls.ArtistAPICalls.getPlaylistFromArtist(mediaDetailVM: self)
  }

  func getPlaylistScreenData(currentUserID: String) {
    MediaDetailAPICalls.UserInfoAPICalls.checksIfUserFollows(.playlist(userID: currentUserID),
                                                             mediaDetailVM: self, itemID: self.mainItem!.id)
    MediaDetailAPICalls.PlaylistAPICalls.getTracksFromPlaylist(mediaDetailVM: self, loadMoreEnabled: true)
  }

  func getAlbumScreenData() {
    MediaDetailAPICalls.UserInfoAPICalls.getArtistBasicInfo(mediaDetailVM: self)
    MediaDetailAPICalls.UserInfoAPICalls.checksIfUserFollows(.album, mediaDetailVM: self, itemID: self.mainItem!.id)
    MediaDetailAPICalls.AlbumAPICalls.getTracksFromAlbum(mediaDetailVM: self, loadMoreEnabled: true)
  }

  func getShowsScreenData() {
    MediaDetailAPICalls.ShowsAPICalls.getEpisodesFromShows(mediaDetailVM: self, loadMoreEnabled: true)
  }

  func getEpisodesScreenData() {
    MediaDetailAPICalls.UserInfoAPICalls.checksIfUserFollows(.show, mediaDetailVM: self, itemID: self.mainItem!.id)
    MediaDetailAPICalls.EpisodeAPICalls.getEpisodeDetails(mediaDetailVM: self)
  }

  func getUserLikedSongsScreenData() {
    MediaDetailAPICalls.UserLikedFollowedMediaAPICalls.getLikedSongs(mediaDetailVM: self)
    MediaDetailAPICalls.UserLibraryInfoAPICalls.getNumberOfLikedSongs(mediaDetailVM: self)
  }

  func getUserSavedEpisodesScreenData() {
    MediaDetailAPICalls.UserLikedFollowedMediaAPICalls.getUserSavedEpisodes(mediaDetailVM: self)
    MediaDetailAPICalls.UserLibraryInfoAPICalls.getNumberOfSavedEpisodes(mediaDetailVM: self)
  }

  // MARK: - API Auxiliary Functions

  func trimAndCommunicateResult(medias: [SpotifyModel.MediaItem],
                                section: MediaDetailSection,
                                limit: Int = 10,
                                loadMoreEnabled: Bool = false,
                                deleteAlmostDuplicateResults: Bool = false) {

    let noDuplicateMedias = getNonDuplicateItems(for: medias, deleteAlmostDuplicateResults: deleteAlmostDuplicateResults)
    // If the api got more than `limit` items, return just the elements within the `limit`
    let mediasWithinTheLimit = noDuplicateMedias.count >= limit ? Array(noDuplicateMedias.prefix(limit)) : noDuplicateMedias

    if loadMoreEnabled {
      mediaCollection[section]! += noDuplicateMedias
    } else {
      mediaCollection[section] = mediasWithinTheLimit
    }

    isLoading[section] = false
  }

  func artistBasicInfoAlreadyLoaded() {
    isLoading[.artistBasicInfo(.artistBasicInfo)] = false
  }

  func getNumberOfLoadedItems(for section: MediaDetailSection) -> Int {
    return numberOfLoadedItemsInSection[section]!
  }

  func increaseNumberOfLoadedItems(for section: MediaDetailSection, by amount: Int) {
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

  // MARK: - Auxiliary Functions not related to API calls

  func cleanAll() {
    mainItem = nil
    detailScreenOrigin = nil
    followedIDs.removeAll()
    cleanAllSection()
  }

  func cleanSectionFor(sectionMediaType: SpotifyModel.MediaTypes) {
    cleanSection(MediaDetailSection.ArtistBasicInfo.self)

    switch sectionMediaType {
    case .album:
      cleanSection(MediaDetailSection.AlbumSections.self)
    case .playlist:
      cleanSection(MediaDetailSection.PlaylistSections.self)
    case .show:
      cleanSection(MediaDetailSection.ShowsSections.self)
    case .artist:
      cleanSection(MediaDetailSection.ArtistSections.self)
    case .episode:
      cleanSection(MediaDetailSection.EpisodeSections.self)
    case .track:
      print("TrackDetailScreen - We have nothing to clean.")
    }
  }

  func cleanUserLikedFollowedSections() {
    cleanSection(MediaDetailSection.UserLikedFollowedMedia.self)
  }

  func setImageColorModelBasedOn(_ firstImageURL: String) {
    imageColorModel = RemoteImageModel(urlString: firstImageURL)
  }

  func returnBasicArtistsInfo() -> [SpotifyModel.MediaItem] {
    return mediaCollection[.artistBasicInfo(.artistBasicInfo)]!
  }

  // MARK: - Private functions

  private func cleanAllSection() {
    cleanSection(MediaDetailSection.ArtistSections.self)
    cleanSection(MediaDetailSection.PlaylistSections.self)
    cleanSection(MediaDetailSection.AlbumSections.self)
    cleanSection(MediaDetailSection.ShowsSections.self)
    cleanSection(MediaDetailSection.EpisodeSections.self)
    cleanSection(MediaDetailSection.ArtistSections.self)
    cleanSection(MediaDetailSection.ArtistBasicInfo.self)
    cleanSection(MediaDetailSection.UserLikedFollowedMedia.self)

    for section in UserLibraryInfoSections.allCases {
      userLibraryInfo[section] = nil
    }
  }

  private func cleanSection<DetailSection: MediaDetailSectionsProtocol & CaseIterable>(_ section: DetailSection.Type) {

    for subSection in section.allCases {
      var sectionInstance: MediaDetailSection?

      if section == MediaDetailSection.ArtistSections.self {
        sectionInstance = .artist(subSection as! MediaDetailSection.ArtistSections)

      } else if section == MediaDetailSection.PlaylistSections.self {
        sectionInstance = .playlist(subSection as! MediaDetailSection.PlaylistSections)

      } else if section == MediaDetailSection.AlbumSections.self {
        sectionInstance = .album(subSection as! MediaDetailSection.AlbumSections)

      } else if section == MediaDetailSection.ShowsSections.self {
        sectionInstance = .shows(subSection as! MediaDetailSection.ShowsSections)

      } else if section == MediaDetailSection.EpisodeSections.self {
        sectionInstance = .episodes(subSection as! MediaDetailSection.EpisodeSections)

      } else if section == MediaDetailSection.ArtistBasicInfo.self {
        sectionInstance = .artistBasicInfo(subSection as! MediaDetailSection.ArtistBasicInfo)

      } else if section == MediaDetailSection.UserLikedFollowedMedia.self {
        sectionInstance = .userLikedFollowedMedia(subSection as! MediaDetailSection.UserLikedFollowedMedia)
      }

      // deletes images in the current section from cache
      if mediaCollection[sectionInstance!] != nil {
        for media in mediaCollection[sectionInstance!]! {
          ImageCache.deleteImageFromCache(imageURL: media.imageURL)
        }
      }

      isLoading[sectionInstance!] = true
      mediaCollection[sectionInstance!] = []
      numberOfLoadedItemsInSection[sectionInstance!] = 0
    }
  }

  private func getNonDuplicateItems(for medias: [SpotifyModel.MediaItem],
                                    deleteAlmostDuplicateResults: Bool = false) -> [SpotifyModel.MediaItem] {
    var trimmedMedias = [SpotifyModel.MediaItem]()
    var nonDuplicateMedias = [SpotifyModel.MediaItem]()

    // Why we check for duplicate items? -
    //  Some API results are exactly the same(same id) which causes crashes

    // Why to use `deleteAlmostDuplicateResults`?
    //  to avoid results like: ["Album Name","Album Name (Radio)"], we delete those almost duplicate items.

    if !deleteAlmostDuplicateResults {
      var mediaIDs = [String]()

      for media in medias {
        if !mediaIDs.contains(media.id) {
          mediaIDs.append(media.id)
          nonDuplicateMedias.append(media)
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
          // Remove the " "(case it has) ("Album Name " -> "Album Name")
          if trimmedMedia.title.last == " " {
            trimmedMedia.title.removeLast()
          }
        }
        trimmedMedias.append(trimmedMedia)
      }
      nonDuplicateMedias = getNonDuplicateMedias(for: trimmedMedias)
    }
    return nonDuplicateMedias
  }

  private func getNonDuplicateMedias(for medias: [SpotifyModel.MediaItem]) -> [SpotifyModel.MediaItem] {
    let nonDuplicateMediaTitles = Set(medias.map { $0.title })
    var nonDuplicateMedias = [SpotifyModel.MediaItem]()

    for title in nonDuplicateMediaTitles {
      let mediaIndex = medias.firstIndex(where: { $0.title == title })!
      nonDuplicateMedias.append(medias[mediaIndex])
    }

    return nonDuplicateMedias
  }

}
