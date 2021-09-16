//
//  SpotifyCloneApp.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/30/21.
//

import SwiftUI

@main
struct SpotifyCloneApp: App {
    var body: some Scene {
      let mainViewModel = MainViewModel()

        WindowGroup {
          MainView(mainViewModel: mainViewModel)
        }
    }
}
