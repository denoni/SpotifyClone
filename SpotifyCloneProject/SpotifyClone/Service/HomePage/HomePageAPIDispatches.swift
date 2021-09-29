//
//  HomePageAPIDispatches.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation
import Alamofire

// TODO: Handle empty responses and errors
// TODO: The data received after decoding should be easier to access

class HomePageAPIDispatches: ObservableObject {

  var trackAPI = APIFetchingTracks()
  var showsAPI = APIFetchingShows()
  var playlistAPI = APIFetchingPlaylists()
  var albumAPI = APIFetchingAlbums()
  var artistAPI = APIFetchingArtists()

  // MARK: - TRACKS
  func getTrack(using endPoint: APIFetchingTracks.TrackEndpointInAPI,
                with accessToken: String,
                limit: Int = 6,
                offset: Int = 0,
                completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    
    trackAPI.getTrack(using: endPoint, with: accessToken, limit: limit,
                      offset: offset, completionHandler: completionHandler)
  }

  // MARK: - SHOWS
  func getShow(using endPoint: APIFetchingShows.ShowsEndpointInAPI,
              with accessToken: String,
              limit: Int = 10,
              offset: Int = 0,
              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    showsAPI.getShow(using: endPoint, with: accessToken, limit: limit,
                     offset: offset, completionHandler: completionHandler)
  }

  // MARK: - PLAYLISTS

  func getPlaylist(using endPoint: APIFetchingPlaylists.PlaylistsEndpointInAPI,
                   with accessToken: String,
                   limit: Int = 10,
                   offset: Int = 0,
                   completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    playlistAPI.getPlaylist(using: endPoint, with: accessToken, limit: limit,
                            offset: offset, completionHandler: completionHandler)
  }

  // MARK: - PLAYLISTS

  func getAlbum(using endPoint: APIFetchingAlbums.AlbumsEndpointInAPI,
                with accessToken: String,
                limit: Int = 10,
                offset: Int = 0,
                completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    albumAPI.getAlbum(using: endPoint, with: accessToken, limit: limit,
                            offset: offset, completionHandler: completionHandler)
  }

  // MARK: - ARTISTS
  func getArtist(using endPoint: APIFetchingArtists.ArtistsEndpointInAPI,
                   with accessToken: String,
                   limit: Int = 10,
                   completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    artistAPI.getArtist(using: endPoint, with: accessToken,
                          limit: limit, completionHandler: completionHandler)
  }
  
}

