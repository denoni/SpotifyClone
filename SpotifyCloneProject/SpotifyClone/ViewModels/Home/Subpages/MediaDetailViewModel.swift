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

  @Published var mediaCollection = [SpotifyModel.MediaItem]()
  @Published var isLoading = true
  @Published var accessToken: String?

  var api = HomePageAPIDispatches()

  func getTopTracksFromArtist() {
    api.getTrack(using: .topTracksFromArtist(artistID: mainItem!.id), with: accessToken!) { tracks in
      guard tracks.count <= 5 else {
        // If the api got more than 5 tracks, return just the first 5
        self.trimAndCommunicateResult(medias: Array(tracks.prefix(5)))
        return
      }
      self.trimAndCommunicateResult(medias: tracks)
    }
  }

  func trimAndCommunicateResult(medias: [SpotifyModel.MediaItem]) {
    var noDuplicateMedias = [SpotifyModel.MediaItem]()
    var mediaIDs = [String]()

    for media in medias {
      if !mediaIDs.contains(media.id) {
        mediaIDs.append(media.id)
        noDuplicateMedias.append(media)
      }
    }
    mediaCollection = noDuplicateMedias
    isLoading = false
  }


  func setVeryFirstImageInfoBasedOn(_ firstImageURL: String) {
    imageColorModel = RemoteImageModel(urlString: firstImageURL)
  }
}
