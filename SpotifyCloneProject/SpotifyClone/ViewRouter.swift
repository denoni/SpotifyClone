//
//  ViewRouter.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/4/21.
//

import SwiftUI

class ViewRouter: ObservableObject {
  @Published var currentPage: Page = .home
}

enum Page {
  case home
  case search
  case myLibrary
}
