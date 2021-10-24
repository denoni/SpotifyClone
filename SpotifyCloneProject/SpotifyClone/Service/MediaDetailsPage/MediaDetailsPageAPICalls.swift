//
//  MediaDetailsPageAPICalls.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/30/21.
//

import Foundation
import Alamofire

// TODO: Handle empty responses and errors

class MediaDetailsPageAPICalls: ObservableObject {

  var trackAPI = APIFetchingTracks()
  var albumAPI = APIFetchingAlbums()
  var playlistAPI = APIFetchingPlaylists()
  var episodeAPI =  APIFetchingEpisodes()
  var basicInfoAPI = APIFetchingBasicInfo()
  var userInfoAPI = APIFetchingUserInfo()

  // MARK: - Artist Screen

  // MARK: Top Tracks From Artist
  func getTopTracksFromArtist(with accessToken: String,
                              artistID: String,
                              limit: Int = 10,
                              offset: Int = 0,
                              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    trackAPI.getTrack(using: .topTracksFromArtist(artistID: artistID),
                      with: accessToken, completionHandler: completionHandler)
  }

  // MARK: Albums From Artist
  func getAlbumsFromArtist(with accessToken: String,
                           artistID: String,
                           completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    albumAPI.getAlbum(using: .artistAlbums(artistID: artistID),
                      with: accessToken, completionHandler: completionHandler)
  }

  // MARK: Playlists From Artist
  func getPlaylistsFromArtist(with accessToken: String,
                              keyWord: String,
                              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    playlistAPI.getPlaylist(using: .playlistWithKeyword(keyWord: keyWord),
                            with: accessToken, completionHandler: completionHandler)
  }


  // MARK: - Playlist Screen

  // MARK: Tracks From Playlist
  func getTracksFromPlaylist(with accessToken: String,
                             playlistID: String,
                             limit: Int = 10,
                             offset: Int = 0,
                             completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    trackAPI.getTrack(using: .tracksFromPlaylist(playlistID: playlistID),
                      with: accessToken, limit: limit, offset: offset,
                      completionHandler: completionHandler)
  }


  // MARK: - Album Screen

  // MARK: Tracks From Album
  func getTracksFromAlbum(with accessToken: String,
                          albumID: String,
                          limit: Int = 10,
                          offset: Int = 0,
                          completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    trackAPI.getTrack(using: .tracksFromAlbum(albumID: albumID),
                      with: accessToken, limit: limit, offset: offset,
                      completionHandler: completionHandler)
  }


  // MARK: - Shows Screen

  // MARK: Episodes From Show
  func getEpisodesFromShow(with accessToken: String,
                           showID: String,
                           limit: Int = 10,
                           offset: Int = 0,
                           completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    episodeAPI.getEpisode(using: .episodesFromShow(showID: showID),
                          with: accessToken, limit: limit, offset: offset,
                          completionHandler: completionHandler)
  }

  // MARK: - Episode Screen

  func getEpisodeDetails(with accessToken: String,
                         episodeID: String,
                         completionHandler: @escaping (SpotifyModel.MediaItem) -> Void) {

    episodeAPI.getEpisodeDetails(with: accessToken,
                                 episodeID: episodeID,
                                 completionHandler: completionHandler)
  }


  // MARK: - Basic Info

  func getArtists(with accessToken: String,
                  artistIDs: [String],
                  completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    basicInfoAPI.getArtists(with: accessToken, artistIDs: artistIDs, completionHandler: completionHandler)
  }

  // MARK: - User Info

  func checksIfUserFollows(_ mediaType: APIFetchingUserInfo.ValidMediaType,
                           with accessToken: String,
                           mediaID: String,
                           completionHandler: @escaping (Bool) -> Void) {
    userInfoAPI.checksIfUserFollows(mediaType, with: accessToken,
                                    mediaID: mediaID, completionHandler: completionHandler)
  }

  func changeFollowingState(to followingState: APIFetchingUserInfo.FollowingState,
                            in mediaType: APIFetchingUserInfo.ValidMediaType,
                            with accessToken: String,
                            mediaID: String,
                            completionHandler: @escaping (Bool) -> Void) {
    userInfoAPI.changeFollowingState(to: followingState, in: mediaType, with: accessToken, mediaID: mediaID, completionHandler: completionHandler)
  }

  // MARK: - User Liked/Followed Media

  func getUserLikedSongs(with accessToken: String,
                         completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    trackAPI.getTrack(using: .userLikedTracks, with: accessToken, completionHandler: completionHandler)
  }

}

