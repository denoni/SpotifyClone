//
//  SpotifyCloneApp.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/30/21.
//

import SwiftUI

@main
struct SpotifyCloneApp: App {
  let mainViewModel: MainViewModel

  init() {
    self.mainViewModel = MainViewModel()
  }

    var body: some Scene {
        WindowGroup {
            ContentView(mainViewModel: mainViewModel)
        }
    }
}
