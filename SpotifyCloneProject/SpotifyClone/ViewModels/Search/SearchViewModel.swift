//
//  SearchViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/20/21.
//

import SwiftUI

class SearchViewModel: ObservableObject {
  var api = SearchPageAPICalls()
  var mainVM: MainViewModel
  @Published var isLoading = true
  @Published var playlists = [SpotifyModel.PlaylistItem]()
  @Published var colors = [Color]()

  @Published var currentSubPage: SearchSubpage = .none

  @Published var pageHistory = [(subPage: SearchSubpage, subPageType: SubPageType)]()

  enum SearchSubpage {
    case none
    case transitionScreen
    case activeSearching

    case trackDetail
    case playlistDetail
    case albumDetail
    case showDetail
    case artistDetail
    case episodeDetail
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

  func goToNoneSubpage() {
    pageHistory.removeAll()
    currentSubPage = .none
  }

  func goToPreviousPage() {
    // removes the current page
    pageHistory.removeLast()

    if pageHistory.isEmpty == false {
      changeSubpageTo(pageHistory.last!.subPage, subPageType: pageHistory.last!.subPageType)

      // removes the page that we just returned to
      pageHistory.removeLast()
      
    } else {
      goToNoneSubpage()
    }

  }

  enum SubPageType {
    case search(searchDetailVM: SearchDetailViewModel, accessToken: String)
    case detail(mediaDetailVM: MediaDetailViewModel, data: SpotifyModel.MediaItem)
  }

  func changeSubpageTo(_ subPage: SearchSubpage,
                       subPageType: SubPageType) {

    self.pageHistory.append((subPage: subPage, subPageType: subPageType))

    currentSubPage = .transitionScreen
    

    // if we change the subpage right away it'll cause a crash
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      switch subPageType {

      case .search(let searchDetailVM, let accessToken):
        searchDetailVM.accessToken = accessToken

      case .detail(let mediaDetailVM, let data):
        mediaDetailVM.clean()
        mediaDetailVM.mainItem = data
        mediaDetailVM.accessToken = self.mainVM.authKey!.accessToken
        mediaDetailVM.setVeryFirstImageInfoBasedOn(data.imageURL)
      }

      self.currentSubPage = subPage

    }
  }

}
