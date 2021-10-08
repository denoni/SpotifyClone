//
//  SearchViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/20/21.
//

import SwiftUI

class SearchViewModel: ObservableObject {
  var api = APIFetchingDataSearchPage()
  var mainVM: MainViewModel
  @Published var isLoading = true
  @Published var playlists = [SpotifyModel.PlaylistItem]()
  @Published var colors = [Color]()

  @Published var currentSubPage: SearchSubpage = .none

  enum SearchSubpage {
    case none
    case activeSearching
  }

  init(mainVM: MainViewModel) {
    self.mainVM = mainVM
  }

  func getCategoriesData() {
    DispatchQueue.main.async {
      self.api.getPlaylists(accessToken: self.mainVM.authKey!.accessToken) { [unowned self] categoryItems in

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



  // MARK: - Non-api Related Functions

  func goToNoneSubpage( ) {
    currentSubPage = .none
  }

  func changeSubpageTo(_ subPage: SearchSubpage,
                       searchDetailViewModel: SearchDetailViewModel) {
    currentSubPage = subPage
  }

}
