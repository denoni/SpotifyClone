//
//  SpotifyModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import Foundation

struct SpotifyModel {

  init() {
  }

  enum MediaTypes {
    case track
    case album
    case playlist
    case show
    case artist
  }

  // This struct will be modified
  struct PlaylistItem: Identifiable {
    var sectionTitle: String
    var name: String
    var imageURL: String
    var id: String
  }
  
  struct MediaItem: Identifiable {
    var title: String
    var previewURL: String
    var imageURL: String
    var author: String
    var type: String
    var isPodcast: Bool
    var isArtist: Bool
    var id: String
    var details: DetailTypes

    func getDetails() -> DetailTypes {
      switch details {
        case .playlists(let playlistDetails):
          return DetailTypes.playlists(playlistDetails: playlistDetails)

        case .artists(let artistDetails):
          return DetailTypes.artists(artistDetails: artistDetails)

        case .shows(let showDetails):
          return DetailTypes.shows(showDetails: showDetails)

        case .tracks(let trackDetails):
          return DetailTypes.tracks(trackDetails: trackDetails)

        case .album(let albumDetails):
          return DetailTypes.album(albumDetails: albumDetails)
      }
    }
  }



  // MARK: - Detail Structs
  enum DetailTypes {
    case shows(showDetails: ShowDetails)
    case tracks(trackDetails: TrackDetails)
    case playlists(playlistDetails: PlaylistDetails)
    case artists(artistDetails: ArtistDetails)
    case album(albumDetails: AlbumDetails)
  }

  
  struct ShowDetails {
    var description: String
    var explicit: Bool
    var numberOfEpisodes: Int
    var href: String
  }

  struct TrackDetails {
    var popularity: Int
    var explicit: Bool
    var durationInMs: Double
    var href: String
    var album: AlbumDetails?
  }

  struct PlaylistDetails {
    var description: String
    var playlistTracks: PlaylistTracks
    var owner: MediaOwner
    var href: String
  }

  struct ArtistDetails {
    var followers: Int
    var genres: [String]
    var popularity: Int
    var href: String
  }

  struct AlbumDetails {
    var name: String
    var numberOfTracks: Int
    var href: String
  }



  // MARK: - Sub structs
  struct PlaylistTracks {
    var href: String
    var numberOfSongs: Int
  }

  struct MediaOwner {
    var href: String
    var displayName: String
  }

}
