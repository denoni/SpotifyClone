//
//  MainViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation

class MainViewModel: ObservableObject {
  @Published private(set) var authKey: AuthKey?
  @Published var currentPage: Page = .home
  @Published var homeScreenIsReady = false
  @Published var showBottomMediaPlayer = true
  
  func finishAuthentication(authKey: AuthKey) {
    self.authKey = authKey
    
    guard self.authKey != nil else {
      fatalError("HomeScreen would be initiated without authKey.")
    }

    homeScreenIsReady = true
  }  
}

enum Page {
  case home
  case search
  case myLibrary
}
