//
//  MediaDetailViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

class MediaDetailViewModel: ObservableObject {
  // - mainItem: The item that was clicked to originate the current DetailView.
  @Published var mainItem: SpotifyModel.MediaItem?
  @Published var imageColorModel = RemoteImageModel(urlString: "")

  @Published var mediaCollection = [Section:[SpotifyModel.MediaItem]]()
  @Published var isLoading = [Section:Bool]()
  @Published var numberOfLoadedItemsInSection = [Section:Int]()
  @Published var accessToken: String?

  init() {
    for section in ArtistSections.allCases {
      isLoading[.artist(section)] = true
      mediaCollection[.artist(section)] = []
      numberOfLoadedItemsInSection[.artist(section)] = 0
    }

    for section in PlaylistSections.allCases {
      isLoading[.playlist(section)] = true
      mediaCollection[.playlist(section)] = []
      numberOfLoadedItemsInSection[.playlist(section)] = 0
    }
  }

  enum Section: Hashable {
    case artist(_ artistSection: ArtistSections)
    case playlist(_ playlistSection: PlaylistSections)
  }

  enum ArtistSections: CaseIterable {
    case topTracksFromArtist
    case albumsFromArtist
    case playlistsFromArtist
  }

  enum PlaylistSections: CaseIterable {
    case tracksFromPlaylist
  }


  var api = MediaDetailsPageAPICalls()

  func getArtistScreenData() {
    ArtistAPICalls.getTopTracksFromArtist(mediaVM: self)
    ArtistAPICalls.getAlbumsFromArtist(mediaVM: self)
    ArtistAPICalls.getPlaylistFromArtist(mediaVM: self)
  }

  func getPlaylistScreenData() {
    PlaylistAPICalls.getTracksFromPlaylist(mediaVM: self)
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

      mediaVM.api.getPlaylistsFromArtist(with: mediaVM.accessToken!, keyWord: keyWord) { playlist in
        mediaVM.trimAndCommunicateResult(medias: playlist, section: .artist(.playlistsFromArtist))
      }
    }

  }


  struct PlaylistAPICalls {

    static func getTracksFromPlaylist(mediaVM: MediaDetailViewModel, loadMoreEnabled: Bool = false) {
      let offset = mediaVM.getNumberOfLoadedItems(for: .playlist(.tracksFromPlaylist))
      mediaVM.increaseNumberOfLoadedItems(for: .playlist(.tracksFromPlaylist), by: 10)

      mediaVM.api.getTracksFromPlaylist(with: mediaVM.accessToken!, playlistID: SpotifyModel.getPlaylistDetails(for: mediaVM.mainItem!).id,
                                        offset: offset) { playlist in
        mediaVM.trimAndCommunicateResult(medias: playlist, section: .playlist(.tracksFromPlaylist), loadMoreEnabled: loadMoreEnabled)
      }
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
    if numberOfLoadedItemsInSection[section]! <= 50 {
      numberOfLoadedItemsInSection[section]! += amount
    }
  }



  // MARK: - Non-API Auxiliary Functions

  func clean() {
    for section in ArtistSections.allCases {
      isLoading[.artist(section)] = true
      mediaCollection[.artist(section)]! = []
    }
    for section in PlaylistSections.allCases {
      isLoading[.playlist(section)] = true
      mediaCollection[.playlist(section)]! = []
    }
  }

  func setVeryFirstImageInfoBasedOn(_ firstImageURL: String) {
    imageColorModel = RemoteImageModel(urlString: firstImageURL)
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
