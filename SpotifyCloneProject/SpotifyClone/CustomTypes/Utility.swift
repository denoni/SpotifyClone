//
//  Utility.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/7/21.
//

import SwiftUI

struct Utility {

  // MARK: - Media Detail Utility
  static func didEverySectionLoaded(in subPage: HomeViewModel.HomeSubpage, mediaDetailVM: MediaDetailViewModel) -> Bool {

    switch subPage {
    case .albumDetail:
      for section in MediaDetailViewModel.AlbumSections.allCases {
        // If any section still loading, return false
        guard mediaDetailVM.isLoading[.album(section)] != true else {
          return false
        }
      }
    case .artistDetail:
      for section in MediaDetailViewModel.ArtistSections.allCases {
        // If any section still loading, return false
        guard mediaDetailVM.isLoading[.artist(section)] != true else {
          return false
        }
      }
    case .playlistDetail:
      for section in MediaDetailViewModel.PlaylistSections.allCases {
        // If any section still loading, return false
        guard mediaDetailVM.isLoading[.playlist(section)] != true else {
          return false
        }
      }
    case .showDetail:
      for section in MediaDetailViewModel.ShowsSections.allCases {
        // If any section still loading, return false
        guard mediaDetailVM.isLoading[.shows(section)] != true else {
          return false
        }
      }
    default:
      fatalError("Didn't implement `didEverySectionLoaded` for \(subPage)")
    }

    // in playlist detail we have no interest in the playlist author.
    if subPage != .playlistDetail {

      // Checks if artist basic info is still loading
      guard mediaDetailVM.isLoading[.artistBasicInfo(.artistBasicInfo)] != true else {
        return false
      }
    }

  // else, return true
  return true
  }

}
