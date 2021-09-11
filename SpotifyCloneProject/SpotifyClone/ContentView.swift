//
//  ContentView.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/30/21.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewRouter: ViewRouter
  @ObservedObject var homeViewModel = HomeViewModel()

  var body: some View {
    ZStack {
            Color.spotifyDarkGray.ignoresSafeArea()
            switch viewRouter.currentPage {
            case .home:
              HomeScreen(homeViewModel: homeViewModel)
            case .search:
              SearchScreen()
            case .myLibrary:
              Text("To be done 🛠").font(.title)
            }
            BottomBar(viewRouter: viewRouter, showMediaPlayer: true)
          }
  }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(viewRouter: ViewRouter())
  }
}
