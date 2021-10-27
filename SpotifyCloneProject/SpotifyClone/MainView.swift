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
  @StateObject var myLibraryVM: MyLibraryViewModel
  @StateObject var searchVM: SearchViewModel
  @StateObject var mediaDetailVM: MediaDetailViewModel

  @StateObject var activeSearchVM = ActiveSearchViewModel()

  init(mainViewModel: MainViewModel) {
    _mainVM = StateObject(wrappedValue: mainViewModel)
    _authVM = StateObject(wrappedValue: AuthViewModel(mainViewModel: mainViewModel))
    _homeVM = StateObject(wrappedValue: HomeViewModel(mainViewModel: mainViewModel))
    _myLibraryVM = StateObject(wrappedValue: MyLibraryViewModel(mainViewModel: mainViewModel))
    _searchVM = StateObject(wrappedValue: SearchViewModel(mainVM: mainViewModel))
    _mediaDetailVM = StateObject(wrappedValue: MediaDetailViewModel(mainVM: mainViewModel))
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
            .environmentObject(activeSearchVM)
            .environmentObject(mediaDetailVM)
        case .myLibrary:
          MyLibraryScreen()
            .environmentObject(myLibraryVM)
            .environmentObject(mediaDetailVM)
        }
        BottomBar(mainVM: mainVM, showMediaPlayer: mainVM.showBottomMediaPlayer)
      }
      .onAppear { mainVM.getCurrentUserInfo() }
      .onChange(of: mainVM.currentPage) { _ in cleanAllPages() }
      .onChange(of: mainVM.currentPageWasRetapped) { _ in goToNoneSubview() }
      .navigationBarTitle("")
      .navigationBarHidden(true)
    } else {
      AuthScreen(authViewModel: AuthViewModel(mainViewModel: mainVM))
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
  }

  private func cleanAllPages() {
    homeVM.goToNoneSubpage()
    searchVM.goToNoneSubpage()
    myLibraryVM.goToNoneSubpage()
    mediaDetailVM.cleanAll()
    ImageCache.deleteAll()
  }

  private func goToNoneSubview() {
    if mainVM.currentPageWasRetapped == true {
      switch mainVM.currentPage {
      case .home:
        homeVM.goToNoneSubpage()
      case .search:
        searchVM.goToNoneSubpage()
      case .myLibrary:
        myLibraryVM.goToNoneSubpage()
      }
    }
    // reset to previous state
    mainVM.currentPageWasRetapped = false
  }

}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(mainViewModel: MainViewModel())
  }
}
