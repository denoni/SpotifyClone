//
//  MainView.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/30/21.
//

import SwiftUI

struct MainView: View {
  @StateObject var mainViewModel: MainViewModel
  @StateObject var authViewModel: AuthViewModel
  @StateObject var homeViewModel: HomeViewModel
  @StateObject var searchViewModel: SearchViewModel

  init(mainViewModel: MainViewModel) {
    _mainViewModel = StateObject(wrappedValue: mainViewModel)
    _authViewModel = StateObject(wrappedValue: AuthViewModel(mainViewModel: mainViewModel))
    _homeViewModel = StateObject(wrappedValue: HomeViewModel(mainViewModel: mainViewModel))
    _searchViewModel = StateObject(wrappedValue: SearchViewModel(mainViewModel: mainViewModel))
  }
  
  var body: some View {
    if mainViewModel.homeScreenIsReady {
      ZStack {
        Color.spotifyDarkGray.ignoresSafeArea()
        switch mainViewModel.currentPage {
        case .home:
          HomeScreen(homeViewModel: homeViewModel)
        case .search:
          SearchScreen(searchViewModel: searchViewModel)
        case .myLibrary:
          Text("To be done 🛠").font(.title)
        }
        BottomBar(mainViewModel: mainViewModel, showMediaPlayer: mainViewModel.showBottomMediaPlayer)
      }
      .navigationBarTitle("")
      .navigationBarHidden(true)
    } else {
      AuthScreen(authViewModel: AuthViewModel(mainViewModel: mainViewModel))
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
  }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(mainViewModel: MainViewModel())
  }
}
