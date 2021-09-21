//
//  SearchViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/20/21.
//

import Foundation

class SearchViewModel: ObservableObject {
  var api = APIFetchingDataSearchPage()
  var mainViewModel: MainViewModel
  @Published var isLoading = true
  @Published var playlists = [SpotifyModel.PlaylistItem]()

  init(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  func getCategoriesData() {
    DispatchQueue.main.async {
      self.api.getPlaylists(accessToken: self.mainViewModel.authKey!.accessToken) { [unowned self] categoryItems in
        self.playlists = categoryItems
        self.isLoading = false
      }
    }
  }

}
