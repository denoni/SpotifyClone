//
//  SearchScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/2/21.
//

// TODO: Make the custom view structures more usable with arguments when called

import SwiftUI

struct SearchScreen: View {

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {

        SearchSection()

      }.padding(.vertical, lateralPadding)
    }
  }
}

struct SearchSection: View {
  @State private var searchInput: String = ""

  var body: some View {
    Text("Search").font(.avenir(.heavy, size: 34))
      .frame(maxWidth: .infinity, alignment: .topLeading)
      .padding(.horizontal, lateralPadding)
    HStack {
      SpotifyTextField(textInput: $searchInput, placeholder: "Artists, Songs, Podcasts...")
    }
      .frame(height: 50)
      .padding(.horizontal, lateralPadding)
  }
}


