//
//  MainView.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/30/21.
//

import SwiftUI

struct MainView: View {
  @StateObject var mainVM: MainViewModel
  @StateObject var authVM: AuthViewModel
  @StateObject var homeVM: HomeViewModel
  @StateObject var searchVM: SearchViewModel

  @StateObject var mediaDetailVM = MediaDetailViewModel()

  init(mainViewModel: MainViewModel) {
    _mainVM = StateObject(wrappedValue: mainViewModel)
    _authVM = StateObject(wrappedValue: AuthViewModel(mainViewModel: mainViewModel))
    _homeVM = StateObject(wrappedValue: HomeViewModel(mainViewModel: mainViewModel))
    _searchVM = StateObject(wrappedValue: SearchViewModel(mainViewModel: mainViewModel))
  }
  
  var body: some View {
    if mainVM.homeScreenIsReady {
      ZStack {
        Color.spotifyDarkGray.ignoresSafeArea()
        switch mainVM.currentPage {
        case .home:
          HomeScreen()
            .environmentObject(homeVM)
            .environmentObject(mediaDetailVM)
        case .search:
          SearchScreen()
            .environmentObject(searchVM)
        case .myLibrary:
          Text("To be done 🛠").font(.title)
        }
        BottomBar(mainVM: mainVM, showMediaPlayer: mainVM.showBottomMediaPlayer)
      }
      .navigationBarTitle("")
      .navigationBarHidden(true)
    } else {
      AuthScreen(authViewModel: AuthViewModel(mainViewModel: mainVM))
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
