//
//  MyLibraryScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/19/21.
//

import SwiftUI

struct MyLibraryScreen: View {
  @EnvironmentObject var myLibraryVM: MyLibraryViewModel

  var body: some View {
    VStack {
      ZStack {
        if didEverySectionLoaded() == false {
          ProgressView()
            .withSpotifyStyle()
            .onAppear {
              myLibraryVM.fetchMyLibraryData()
            }
        } else {
          MyLibraryItemsScrollView(medias: getMyLibraryMedias())
        }

        MyLibraryTopBar()
      }
    }
  }


  // MARK: - Auxiliary functions

  func getMyLibraryMedias() -> [SpotifyModel.MediaItem] {
    var myLibraryMedias = [SpotifyModel.MediaItem]()

    for section in MyLibraryViewModel.Section.allCases {
      myLibraryMedias += myLibraryVM.mediaCollection[section]!
    }

    return myLibraryMedias
  }

  func didEverySectionLoaded() -> Bool {
    for key in myLibraryVM.isLoading.keys {
      // If any section still loading, return false
      guard myLibraryVM.isLoading[key] != true else {
        return false
      }
    }
    // else, return true
    return true
  }

}
