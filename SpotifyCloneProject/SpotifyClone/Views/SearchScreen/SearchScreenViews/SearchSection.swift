//
//  SearchSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct SearchSection: View {
  @State private var searchInput: String = ""

  var body: some View {
    VStack {
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
}
