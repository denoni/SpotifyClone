//
//  SearchViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/20/21.
//

import SwiftUI

class SearchViewModel: ObservableObject {
  var api = APIFetchingDataSearchPage()
  var mainViewModel: MainViewModel
  @Published var isLoading = true
  @Published var playlists = [SpotifyModel.PlaylistItem]()
  @Published var colors = [Color]()

  init(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func getCategoriesData() {
    DispatchQueue.main.async {
      self.api.getPlaylists(accessToken: self.mainViewModel.authKey!.accessToken) { [unowned self] categoryItems in

        // Generate the cards' color here to stop the random
        // color from being changed every time the view updates.
        for _ in categoryItems.indices {
          self.colors.append(Color.random)
        }

        self.playlists = categoryItems
        self.isLoading = false
      }
    }
  }

}
