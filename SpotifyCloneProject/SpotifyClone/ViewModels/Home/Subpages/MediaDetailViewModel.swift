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

  func trimAndCommunicateResult(medias: [SpotifyModel.MediaItem], section: Section, limit: Int = 5) {

    // If the api got more than `limit` items, return just the elements within the `limit`
    let mediasWithinTheLimit = medias.count >= limit ? Array(medias.prefix(limit)) : medias
    var noDuplicateMedias = [SpotifyModel.MediaItem]()
    var mediaIDs = [String]()

    for media in mediasWithinTheLimit {
      if !mediaIDs.contains(media.id) {
        mediaIDs.append(media.id)
        noDuplicateMedias.append(media)
      }
    }
    mediaCollection[section] = noDuplicateMedias
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
}
