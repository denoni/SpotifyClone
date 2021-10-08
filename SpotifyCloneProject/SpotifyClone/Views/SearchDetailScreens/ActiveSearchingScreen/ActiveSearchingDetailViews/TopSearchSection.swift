//
//  TopSearchSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import SwiftUI

struct TopSearchSection: View {
  @EnvironmentObject var searchVM: SearchViewModel
  @Binding var searchInput: String

  var body: some View {
    VStack(spacing: 0) {
      Color.spotifyMediumGray
        .ignoresSafeArea()
        .frame(height: 0)
      HStack {
        SearchField(searchInput: $searchInput)
        Text("Cancel")
          .padding(.trailing, Constants.paddingStandard)
          .padding(.leading, 5)
          .onTapGesture {
            searchVM.goToNoneSubpage()
          }
      }
      .padding(.bottom, 8)
      .background(Color.spotifyMediumGray)
      Spacer()
    }
  }

  private struct SearchField: View {
    @Binding var searchInput: String

    var body: some View {
      HStack {
        TextField("Artists, Songs, Podcasts...", text: $searchInput)
          .padding(.horizontal, Constants.paddingLarge)
      }
      .padding(8)
      .background(Color.spotifyLightGray)
      .cornerRadius(Constants.radiusStandard)
      .overlay(
        HStack {
          Image("search-unselected")
            .resizeToFit()
            .padding(.vertical, 10)
          Spacer()
        }
        .padding(.horizontal, Constants.paddingSmall)
      )
      .padding(.leading, Constants.paddingStandard)
    }
  }
}

