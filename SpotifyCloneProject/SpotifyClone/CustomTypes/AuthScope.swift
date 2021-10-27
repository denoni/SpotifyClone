//
//  AuthScope.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/16/21.
//

import Foundation

enum AuthScope: String, CaseIterable {

  case userReadPrivate = "user-read-private"
  case userReadEmail = "user-read-email"

  case userLibraryRead = "user-library-read"
  case userLibraryModify = "user-library-modify"

  case userTopRead = "user-top-read"
  case userReadRecentlyPlayed = "user-read-recently-played"
  case userReadCurrentlyPlaying = "user-read-currently-playing"

  case userReadPlaybackPosition = "user-read-playback-position"
  case userReadPlaybackState = "user-read-playback-state"
  case userModifyPlaybackState = "user-modify-playback-state"

  case playlistReadPublic = "playlist-read-public"
  case playlistReadPrivate = "playlist-read-private"
  case playlistReadCollaborative = "playlist-read-collaborative"

  case playlistModifyPublic = "playlist-modify-public"
  case playlistModifyPrivate = "playlist-modify-private"

  case userFollowRead = "user-follow-read"
  case userFollowModify = "user-follow-modify"

  case ugcImageUpload = "ugc-image-upload"
}
