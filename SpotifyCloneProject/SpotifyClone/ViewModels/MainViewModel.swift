//
//  MainViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation

class MainViewModel: ObservableObject {
  var api = MainViewModelAPICalls()
  @Published private(set) var authKey: AuthKey?
  @Published var currentPage: Page = .home
  @Published var currentPageWasRetapped = false
  @Published var homeScreenIsReady = false
  @Published var showBottomMediaPlayer = true

  @Published var currentUserProfileInfo: SpotifyModel.CurrentUserProfileInfo?

  func finishAuthentication(authKey: AuthKey) {
    self.authKey = authKey
    
    guard self.authKey != nil else {
      fatalError("HomeScreen would be initiated without authKey.")
    }

    homeScreenIsReady = true
  }

  func getCurrentUserInfo() {
    api.getCurrentUserInfo(with: authKey!.accessToken) { userInfo in
      self.currentUserProfileInfo = userInfo
    }
  }

  enum Page {
    case home
    case search
    case myLibrary
  }

}


