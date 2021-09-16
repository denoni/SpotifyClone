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

  init(mainViewModel: MainViewModel) {
    _mainViewModel = StateObject(wrappedValue: mainViewModel)
    _authViewModel = StateObject(wrappedValue: AuthViewModel(mainViewModel: mainViewModel))
    _homeViewModel = StateObject(wrappedValue: HomeViewModel(mainViewModel: mainViewModel))
  }



  var body: some View {
    if mainViewModel.homeScreenIsReady {
      ZStack {
        Color.spotifyDarkGray.ignoresSafeArea()
        switch mainViewModel.currentPage {
        case .home:
          HomeScreen(homeViewModel: homeViewModel)
        case .search:
          SearchScreen()
        case .myLibrary:
          Text("To be done 🛠").font(.title)
        }
        BottomBar(mainViewModel: mainViewModel, showMediaPlayer: true)
      }
    } else {
      AuthScreen(authViewModel: AuthViewModel(mainViewModel: mainViewModel))
    }
  }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(mainViewModel: MainViewModel())
  }
}


//// -----------------------------------------------------------------
//// TODO : -- TEMPORARY --
//VStack(alignment: .center, spacing: 50) {
//
//  // Shows Track Item that was fetched from API
//  Group {
//    if authViewModel.trackItemIsAvailable {
//      VStack(alignment: .center) {
//
//        RemoteImage(url: authViewModel.trackItem!.imageURL)
//          .aspectRatio(1/1, contentMode: .fill)
//          .padding(.horizontal, 50)
//          .padding(.vertical, 20)
//
//        Text(authViewModel.trackItem!.name)
//          .bold()
//          .font(.title2)
//
//        Text(authViewModel.trackItem!.artist)
//          .opacity(0.6)
//      }
//    }
//  }
//
//  // Shows Auth Key fetched from API
//  VStack(alignment: .center) {
//    Text(authViewModel.authKeyIsAvailable ? "Auth key:" : "Auth key not ready." )
//      .foregroundColor(Color.spotifyGreen)
//      .bold()
//      .font(.title)
//    Text(authViewModel.authKeyIsAvailable ? authViewModel.authKey!.accessToken : "")
//      .font(.footnote)
//      .multilineTextAlignment(.center)
//  }
//}
//// -----------------------------------------------------------------
