//
//  MyLibraryPageAPICalls.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import Foundation
import Alamofire

class MyLibraryPageAPICalls: ObservableObject {

  private var trackAPI = APIFetchingTracks()
  private var showsAPI = APIFetchingShows()
  private var playlistAPI = APIFetchingPlaylists()
  private var albumAPI = APIFetchingAlbums()
  private var artistAPI = APIFetchingArtists()

  // MARK: - PLAYLISTs
  func getCurrentUserPlaylists(with accessToken: String,
                               completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    playlistAPI.getPlaylist(using: .currentUserPlaylists, with: accessToken, completionHandler: completionHandler)
  }

  // MARK: - ARTISTs
  func getCurrentUserArtists(with accessToken: String,
                             completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    artistAPI.getArtist(using: .userFollowedArtists, with: accessToken, completionHandler: completionHandler)
  }

  // MARK: - SHOWs
  func getCurrentUserShows(with accessToken: String,
                           completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    showsAPI.getShow(using: .followedPodcasts, with: accessToken, completionHandler: completionHandler)
  }

}
