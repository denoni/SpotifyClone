//
//  SearchSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct SearchSection: View {
  @EnvironmentObject var searchVM: SearchViewModel
  @EnvironmentObject var searchDetailVM: SearchDetailViewModel
  @State private var searchInput: String = ""

  var body: some View {
    VStack {
      Text("Search").font(.avenir(.heavy, size: Constants.fontXLarge))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, Constants.paddingStandard)
      HStack {
        SpotifyTextField(textInput: $searchInput, placeholder: "Artists, Songs, Podcasts...")
      }
      .frame(height: 50)
      .padding(.horizontal, Constants.paddingStandard)
      .onTapGesture {
        searchVM.changeSubpageTo(.activeSearching,
                                 searchDetailViewModel: searchDetailVM)
      }
    }
  }
}
