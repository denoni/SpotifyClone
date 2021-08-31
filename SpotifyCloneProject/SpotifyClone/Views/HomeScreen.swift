//
//  HomeScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/31/21.
//

import SwiftUI

struct HomeScreen: View {
  var body: some View {
    RadialGradientBackground()
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        SmallSongCardsGrid()
          .padding(.horizontal, 25)
          .padding(.bottom, 50)
      }.padding(.vertical, 25)
    }
  }
}

struct RadialGradientBackground: View {
  let backgroundGradientColor = Color(red: 0.051, green: 0.608, blue: 0.784)

  var body: some View {
    RadialGradient(gradient: Gradient(colors: [backgroundGradientColor.opacity(0.35), backgroundGradientColor.opacity(0.0)]),
                   center: .topLeading,
                   startRadius: 10,
                   endRadius: 600)
      .ignoresSafeArea()
  }
}

struct SmallSongCardsGrid: View {
  var body: some View {
    VStack(spacing: 12) {
      HStack {
        Text("Good Evening").font(.avenir(.heavy, size: 26))
          .frame(maxWidth: .infinity, alignment: .topLeading)
        Image("settings")
          .resizable()
          .aspectRatio(1/1, contentMode: .fit)
          .padding(5)
      }.frame(height: 30)
      VStack(spacing: 12) {
        HStack(spacing: 12) {
          SmallSongCard(image: Image("shape-of-you-cover"),
                        title: "Shape of You")
          SmallSongCard(image: Image("prayer-in-c-cover"),
                        title: "Prayer in C")
        }
        HStack(spacing: 12) {
          SmallSongCard(image: Image("la-casa-de-papel-cover"),
                        title: "La Casa de Papel Soundtrack")
          SmallSongCard(image: Image("this-is-logic-cover"),
                        title: "This is Logic")
        }
        HStack(spacing: 12) {
          SmallSongCard(image: Image("your-mix-1-cover"),
                        title: "Your Mix 1")
          SmallSongCard(image: Image("bohemian-rhapsody-cover"),
                        title: "Bohemian Rhapsody")
        }
      }
    }
  }
}
