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

  func setVeryFirstImageInfoBasedOn(_ firstImageURL: String) {
    imageColorModel = RemoteImageModel(urlString: firstImageURL)
  }
}
