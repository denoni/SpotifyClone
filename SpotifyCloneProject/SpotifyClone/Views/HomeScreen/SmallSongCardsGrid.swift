//
//  SmallSongCardsGrid.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct SmallSongCardsGrid: View {
  var body: some View {
    VStack(spacing: spacingSmallItems) {
      HStack {
        Text("Good Evening")
          .spotifyTitle(withPadding: true)
        Image("settings")
          .resizeToFit()
          .padding(5)
      }.frame(height: 30)
      VStack(spacing: spacingSmallItems) {
        HStack(spacing: spacingSmallItems) {
          SmallSongCard(image: Image("shape-of-you-cover"),
                        title: "Shape of You")
          SmallSongCard(image: Image("prayer-in-c-cover"),
                        title: "Prayer in C")
        }
        HStack(spacing: spacingSmallItems) {
          SmallSongCard(image: Image("la-casa-de-papel-cover"),
                        title: "La Casa de Papel Soundtrack")
          SmallSongCard(image: Image("this-is-logic-cover"),
                        title: "This is Logic")
        }
        HStack(spacing: spacingSmallItems) {
          SmallSongCard(image: Image("your-mix-1-cover"),
                        title: "Your Mix 1")
          SmallSongCard(image: Image("bohemian-rhapsody-cover"),
                        title: "Bohemian Rhapsody")
        }
      }
    }
  }
}


