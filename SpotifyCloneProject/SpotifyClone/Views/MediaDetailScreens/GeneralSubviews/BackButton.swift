//
//  BackButton.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct BackButton: View {
  var backButtonShouldReturnTo: MediaDetailViewModel.DetailScreenOrigin
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var body: some View {
    VStack {
      HStack {
        Image("down-arrow")
          .resizeToFit()
          .rotationEffect(Angle.degrees(90))
        Spacer()
      }
      .frame(height: 20)
      .onTapGesture {
        switch backButtonShouldReturnTo {
        case .home(let homeVM):
          homeVM.goToPreviousPage()
        case .search(let searchVM):
          searchVM.goToPreviousPage()
        case .myLibrary(let myLibraryVM):
          myLibraryVM.goToPreviousPage()
        }
      }
    }
  }
}
