//
//  Utility.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/7/21.
//

import SwiftUI

struct Utility {

  // MARK: - Time formatter
  enum TimeFormat {
    case seconds(_ sec: Double)
    case milliseconds(_ ms: Double)
  }

  static func formatTimeToHourMinSec(for time: TimeFormat, spelledOut: Bool = false) -> String {
    var timeInSeconds: Double {
      switch time {
      case .seconds(let sec):
        return sec
      case .milliseconds(let ms):
        return ms / 1000
      }
    }
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

    guard !timeInSeconds.isNaN else {
      if spelledOut {
        return "0 min"
      } else {
        return "00:00"
      }
    }

    if spelledOut {
      guard timeInSeconds >= 60 else {
        return "\(Int(timeInSeconds)) sec"
      }
      return timeHMSFormatterSpelledOut.string(from: timeInSeconds)!
    } else {
      return timeHMSFormatter.string(from: timeInSeconds)!
    }
  }

  // MARK: - Data formatter
  static func getSpelledOutDate(from dateString: String) -> String {
    let formatter = DateFormatter()

    formatter.dateFormat = "yyyy-MM-dd"
    guard let releaseDate = formatter.date(from: dateString) else {
      return ""
    }

    // Checks if the date is today/yesterday or not
    let currentDate = Date()
    let numberOfSecondsInADay: Double = 86400

    // Checks if release date was less than 24 hours ago
    if Double(currentDate.timeIntervalSince(releaseDate)) < numberOfSecondsInADay {
      return "Today"
    }

    // Checks if release date was less than 2 day ago
    if Double(currentDate.timeIntervalSince(releaseDate)) < numberOfSecondsInADay * 2 {
      return "Yesterday"
    }

    formatter.dateStyle = .medium
    formatter.timeStyle = .none

    return formatter.string(from: releaseDate)
  }

  // MARK: - Media Detail Utility
  static func didEverySectionLoaded(in subPage: HomeViewModel.HomeSubpage, mediaDetailVM: MediaDetailViewModel) -> Bool {

    switch subPage {
    case .albumDetail:
      for section in MediaDetailSection.AlbumSections.allCases {
        // If any section still loading, return false
        guard mediaDetailVM.isLoading[.album(section)] != true else {
          return false
        }
      }
    case .artistDetail:
      for section in MediaDetailSection.ArtistSections.allCases {
        guard mediaDetailVM.isLoading[.artist(section)] != true else {
          return false
        }
      }
    case .playlistDetail:
      for section in MediaDetailSection.PlaylistSections.allCases {
        guard mediaDetailVM.isLoading[.playlist(section)] != true else {
          return false
        }
      }
    case .showDetail:
      for section in MediaDetailSection.ShowsSections.allCases {
        guard mediaDetailVM.isLoading[.shows(section)] != true else {
          return false
        }
      }
    case .episodeDetail:
      for section in MediaDetailSection.EpisodeSections.allCases {
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

  // MARK: Checks if user follows/saved an item
  static func checkIfIsFollowingItem(_ itemID: String, mediaDetailVM: MediaDetailViewModel) -> MediaDetailViewModel.CurrentFollowingState {
    guard mediaDetailVM.followedIDs[itemID] != nil else { return .isNotFollowing }
    return mediaDetailVM.followedIDs[itemID]!
  }

  // MARK: - Navigation helper functions

  // MARK: changeSubpage of a ViewModel
  static func changeSubpage(to destinySubpage: MediaDetailViewModel.BasicDetailSubpages,
                            mediaDetailVM: MediaDetailViewModel,
                            withData data: SpotifyModel.MediaItem) {

    let homeVMDestinySubpage: HomeViewModel.HomeSubpage
    let searchVMDestinySubpage: SearchViewModel.SearchSubpage
    let myLibraryVMDestinySubpage: MyLibraryViewModel.MyLibrarySubpage

    switch destinySubpage {
    case .albumDetail:
      homeVMDestinySubpage = .albumDetail
      searchVMDestinySubpage = .albumDetail
      myLibraryVMDestinySubpage = .albumDetail
    case .playlistDetail:
      homeVMDestinySubpage = .playlistDetail
      searchVMDestinySubpage = .playlistDetail
      myLibraryVMDestinySubpage = .playlistDetail
    case .trackDetail:
      homeVMDestinySubpage = .trackDetail
      searchVMDestinySubpage = .trackDetail
      myLibraryVMDestinySubpage = .trackDetail
    case .showDetail:
      homeVMDestinySubpage = .showDetail
      searchVMDestinySubpage = .showDetail
      myLibraryVMDestinySubpage = .showDetail
    case .artistDetail:
      homeVMDestinySubpage = .artistDetail
      searchVMDestinySubpage = .artistDetail
      myLibraryVMDestinySubpage = .artistDetail

    case .episodeDetail:
      homeVMDestinySubpage = .episodeDetail
      searchVMDestinySubpage = .episodeDetail
      myLibraryVMDestinySubpage = .episodeDetail
    }

    switch mediaDetailVM.detailScreenOrigin {
    case .home(let homeVM):
      homeVM.changeSubpageTo(homeVMDestinySubpage,
                             mediaDetailVM: mediaDetailVM,
                             withData: data)
    case .search(let searchVM):
      searchVM.changeSubpageTo(searchVMDestinySubpage, subPageType: .detail(mediaDetailVM: mediaDetailVM,
                                                                            data: data))
    case .myLibrary(let myLibraryVM):
      myLibraryVM.changeSubpageTo(myLibraryVMDestinySubpage,
                                  mediaDetailVM: mediaDetailVM,
                                  withData: data)
    default:
      fatalError("Missing detail screen origin.")
    }
  }

  // MARK: goToPreviousPage of a ViewModel
  static func goToPreviousPage(mediaDetailVM: MediaDetailViewModel) {
    switch mediaDetailVM.detailScreenOrigin {
    case .home(let homeVM):
      homeVM.goToPreviousPage()
    case .search(let searchVM):
      searchVM.goToPreviousPage()
    case .myLibrary(let myLibraryVM):
      myLibraryVM.goToPreviousPage()
    default:
      fatalError("Missing detail screen origin.")
    }
  }

  // MARK: Show and hide MediaPlayer
  static func showOrHideMediaPlayer(shouldShowMediaPlayer: Bool, mediaDetailVM: MediaDetailViewModel) {
    switch mediaDetailVM.detailScreenOrigin {
    case .home(let homeVM):
      homeVM.mainVM.showBottomMediaPlayer = shouldShowMediaPlayer
    case .search(let searchVM):
      searchVM.mainVM.showBottomMediaPlayer = shouldShowMediaPlayer
    case .myLibrary(let myLibraryVM):
      myLibraryVM.mainVM.showBottomMediaPlayer = shouldShowMediaPlayer
    default:
      break
    }
  }

}
