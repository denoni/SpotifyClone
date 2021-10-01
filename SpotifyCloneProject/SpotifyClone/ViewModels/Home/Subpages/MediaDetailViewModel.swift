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
  @Published var accessToken: String?

  init() {
    for section in Section.allCases {
      isLoading[section] = true
      mediaCollection[section] = []
    }
  }

  enum Section: CaseIterable {
    case topTracksFromArtist
    case albumsFromArtist
    case playlistsFromArtist
  }

  var api = MediaDetailsPageAPICalls()

  func getTopTracksFromArtist() {
    api.getTopTracksFromArtist(with: accessToken!, artistID: mainItem!.id) { tracks in
      self.trimAndCommunicateResult(medias: tracks, section: .topTracksFromArtist)
    }
  }

  func getAlbumsFromArtist() {
    api.getAlbumsFromArtist(with: accessToken!, artistID: mainItem!.id) { albums in
      self.trimAndCommunicateResult(medias: albums, section: .albumsFromArtist)
    }
  }

  func getPlaylistFromArtist() {
    // Remote special characters artist title(name)
    let keyWord: String = mainItem!.title.folding(options: .diacriticInsensitive, locale: .current)
    
    api.getPlaylistsFromArtist(with: accessToken!, keyWord: keyWord) { playlist in
      self.trimAndCommunicateResult(medias: playlist, section: .playlistsFromArtist, limit: 10)
    }
  }


  // MARK: - Auxiliary Functions

  func trimAndCommunicateResult(medias: [SpotifyModel.MediaItem],
                                section: Section,
                                limit: Int = 5) {

    let noDuplicateMedias = getNonDuplicateItems(for: medias)

    // If the api got more than `limit` items, return just the elements within the `limit`
    let mediasWithinTheLimit = noDuplicateMedias.count >= limit ? Array(noDuplicateMedias.prefix(limit)) : noDuplicateMedias

    mediaCollection[section] = mediasWithinTheLimit
    isLoading[section] = false
  }

  func clean() {
    for section in Section.allCases {
      isLoading[section] = true
    }
  }

  func setVeryFirstImageInfoBasedOn(_ firstImageURL: String) {
    imageColorModel = RemoteImageModel(urlString: firstImageURL)
  }

  func getNonDuplicateItems(for medias: [SpotifyModel.MediaItem]) -> [SpotifyModel.MediaItem] {
    var trimmedMedias = [SpotifyModel.MediaItem]()

    // Why we check for duplicate items? -
    //  Some artists have a lot of songs/albums with the same medias, but with minor differences,
    //  to avoid results like: ["Album Name","Album Name (Radio)"], we delete those duplicate items.

    for media in medias {
      var trimmedMedia = media

      if media.title.contains("(") {
        let firstOccurrenceBraces = media.title.firstIndex(of: "(")!
        let lastIndex = media.title.endIndex

        // Remove everything after the first "("
        trimmedMedia.title.removeSubrange(firstOccurrenceBraces ..< lastIndex)
        // Remove the " " ("Album Name " -> "Album Name")
        trimmedMedia.title.removeLast()
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

    return noDuplicateMedias
  }

}
