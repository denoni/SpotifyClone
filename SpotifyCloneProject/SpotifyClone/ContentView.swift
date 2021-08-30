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
        
        Text("Spotify")
          .font(.avenir(.heavy, size: 32))
          .foregroundColor(Color.spotifyGreen)
          .padding()
      }
  }
}



// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
