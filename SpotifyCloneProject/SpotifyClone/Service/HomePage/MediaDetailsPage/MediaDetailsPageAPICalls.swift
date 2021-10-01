//
//  MediaDetailsPageAPICalls.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/30/21.
//

import Foundation
import Alamofire

// TODO: Handle empty responses and errors
// TODO: The data received after decoding should be easier to access

class MediaDetailsPageAPICalls: ObservableObject {

  var trackAPI = APIFetchingTracks()
  var albumAPI = APIFetchingAlbums()
  var playlistAPI = APIFetchingPlaylists()

  // MARK: - Top Tracks From Artist
  func getTopTracksFromArtist(with accessToken: String,
                              artistID: String,
                              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    trackAPI.getTrack(using: .topTracksFromArtist(artistID: artistID),
                      with: accessToken, completionHandler: completionHandler)
  }

  // MARK: - Albums From Artist
  func getAlbumsFromArtist(with accessToken: String,
                           artistID: String,
                           completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    albumAPI.getAlbum(using: .artistAlbums(artistID: artistID),
                      with: accessToken, completionHandler: completionHandler)
  }

  // MARK: - Playlists From Artist
  func getPlaylistsFromArtist(with accessToken: String,
                              keyWord: String,
                              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    playlistAPI.getPlaylist(using: .playlistWithKeyword(keyWord: keyWord),
                            with: accessToken, completionHandler: completionHandler)
  }

  // MARK: - Tracks From Playlist
  func getTracksFromPlaylist(with accessToken: String,
                                playlistID: String,
                                completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    trackAPI.getTrack(using: .tracksFromPlaylist(playlistID: playlistID),
                      with: accessToken, completionHandler: completionHandler)
  }


}

