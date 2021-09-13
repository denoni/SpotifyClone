//
//  SpotifyCloneApp.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/30/21.
//

import SwiftUI

@main
struct SpotifyCloneApp: App {
  @StateObject var viewRouter = ViewRouter()
    var body: some Scene {
        WindowGroup {
          AuthScreen()
//            ContentView(viewRouter: viewRouter)
        }
    }
}
