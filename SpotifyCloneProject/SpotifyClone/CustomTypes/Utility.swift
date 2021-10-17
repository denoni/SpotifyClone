//
//  Utility.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/7/21.
//

import SwiftUI

struct Utility {

  // MARK: - Convert ms to HMS hour,minutes, seconds

  static func formatSecondsToHMS(_ seconds: Double, spelledOut: Bool = false) -> String {
    let timeHMSFormatter: DateComponentsFormatter = {
      let formatter = DateComponentsFormatter()
      formatter.unitsStyle = .positional
      formatter.allowedUnits = [.minute, .second]
      formatter.zeroFormattingBehavior = [.pad]
      return formatter
    }()

    let timeHMSFormatterSpelledOut: DateComponentsFormatter = {
      let formatter = DateComponentsFormatter()
      formatter.unitsStyle = .short
      formatter.allowedUnits = [.minute]
      return formatter
    }()

    guard !seconds.isNaN else {
      if spelledOut {
        return "0 min"
      } else {
        return "00:00"
      }
    }

    if spelledOut {
      guard seconds >= 60 else {
        return "\(Int(seconds)) sec"
      }
      return timeHMSFormatterSpelledOut.string(from: seconds)!
    } else {
      return timeHMSFormatter.string(from: seconds)!
    }
  }


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
        guard mediaDetailVM.isLoading[.artist(section)] != true else {
          return false
        }
      }
    case .playlistDetail:
      for section in MediaDetailViewModel.PlaylistSections.allCases {
        guard mediaDetailVM.isLoading[.playlist(section)] != true else {
          return false
        }
      }
    case .showDetail:
      for section in MediaDetailViewModel.ShowsSections.allCases {
        guard mediaDetailVM.isLoading[.shows(section)] != true else {
          return false
        }
      }
    case .episodeDetail:
      for section in MediaDetailViewModel.EpisodeSections.allCases {
        guard mediaDetailVM.isLoading[.episodes(section)] != true else {
          return false
        }
      }
    default:
      fatalError("Didn't implement `didEverySectionLoaded` for \(subPage)")
    }

    // in playlist/show/episode's detail screen we have no interest in the playlist author.
    if subPage != .playlistDetail && subPage != .showDetail && subPage != .episodeDetail {
      // Checks if artist basic info is still loading
      guard mediaDetailVM.isLoading[.artistBasicInfo(.artistBasicInfo)] != true else {
        return false
      }
    }

  // else, return true
  return true
  }

}
