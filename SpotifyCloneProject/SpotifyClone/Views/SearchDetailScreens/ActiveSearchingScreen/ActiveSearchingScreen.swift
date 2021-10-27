//
//  ActiveSearchingScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import SwiftUI

struct ActiveSearchingScreen: View {
  @EnvironmentObject var activeSearchVM: ActiveSearchViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State var searchInput = ""

  var body: some View {
    ZStack(alignment: .top) {
      LinearGradient(gradient: Gradient(colors: [.spotifyLightGray, .spotifyDarkGray]),
                     startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()

      // The scroll view of responses
      Rectangle()
        .foregroundColor(.clear)
        .overlay(SearchResponsesScrollView())

      // The top bar search and the bottom navigation bar
      VStack {
        TopSearchSection(searchInput: $searchInput)
          // So when the page appears, the focus automatically goes to text field(keyboard opens).
          .introspectTextField { textField in textField.becomeFirstResponder() }
          .onChange(of: searchInput) { _ in
            activeSearchVM.search(for: searchInput)
          }
        BottomBar(mainVM: mediaDetailVM.mainVM)
      }
    }
  }
}

// MARK: - Preview

struct ActiveSearchingScreen_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      ActiveSearchingScreen()
      BottomBar(mainVM: MainViewModel())
    }
  }
}
