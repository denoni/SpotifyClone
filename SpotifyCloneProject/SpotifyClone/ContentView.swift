//
//  ContentView.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/30/21.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var mainViewModel: MainViewModel
  @ObservedObject var homeViewModel: HomeViewModel
  @ObservedObject var authViewModel: AuthViewModel

  init(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
    self.homeViewModel = HomeViewModel(mainViewModel: mainViewModel)
    self.authViewModel = AuthViewModel(mainViewModel: mainViewModel)
  }



  var body: some View {
    ZStack {
      Color.spotifyDarkGray.ignoresSafeArea()
      switch mainViewModel.currentPage {
      case .auth:
        AuthScreen(authViewModel: authViewModel)
      case .home:
        HomeScreen(homeViewModel: homeViewModel)
      case .search:
        SearchScreen()
      case .myLibrary:
        Text("To be done 🛠").font(.title)
      }
      BottomBar(mainViewModel: mainViewModel, showMediaPlayer: true)
    }
  }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(mainViewModel: MainViewModel())
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
