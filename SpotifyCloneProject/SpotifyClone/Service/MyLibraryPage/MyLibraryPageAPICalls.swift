//
//  MyLibraryPageAPICalls.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import Foundation
import Alamofire

class MyLibraryPageAPICalls: ObservableObject {

  var trackAPI = APIFetchingTracks()
  var showsAPI = APIFetchingShows()
  var playlistAPI = APIFetchingPlaylists()
  var albumAPI = APIFetchingAlbums()
  var artistAPI = APIFetchingArtists()


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

}
