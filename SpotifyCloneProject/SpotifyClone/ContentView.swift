//
//  ContentView.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/30/21.
//

import SwiftUI

struct ContentView: View {

  var body: some View {
      ZStack {
        Color.spotifyDarkGray.ignoresSafeArea()
        SearchScreen()
        BottomBar(showMediaPlayer: false)
      }
    }
  }


// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
