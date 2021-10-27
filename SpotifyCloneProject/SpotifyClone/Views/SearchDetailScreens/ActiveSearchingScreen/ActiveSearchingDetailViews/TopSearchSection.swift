//
//  TopSearchSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import SwiftUI
import Introspect

struct TopSearchSection: View {
  @EnvironmentObject var searchVM: SearchViewModel
  @EnvironmentObject var activeSearchVM: ActiveSearchViewModel

  @Binding var searchInput: String

  var body: some View {
    VStack(spacing: 0) {
      // To cover the safe area
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
      .padding(.top, Constants.paddingSmall)
      .background(Color.spotifyMediumGray)

      HStack {
        FilterSelectionBar(currentViewModel: activeSearchVM)
          .padding(.top, 5)
          .padding(.bottom, 20)
      }
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
