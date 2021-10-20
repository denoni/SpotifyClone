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

  // MARK: - PLAYLISTS
  func getCurrentUserPlaylists(with accessToken: String,
                               completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    playlistAPI.getPlaylist(using: .currentUserPlaylists, with: accessToken, completionHandler: completionHandler)
  }

}
