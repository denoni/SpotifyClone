//
//  MainViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation

class MainViewModel: ObservableObject {
  @Published private(set) var authKey: AuthKey?
  @Published var currentPage: Page = .auth

  func finishedAuthentication(authKey: AuthKey) {
    self.authKey = authKey
    currentPage = .home
  }
}

enum Page {
  case auth
  case home
  case search
  case myLibrary
}
