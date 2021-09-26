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




//  case .shows(let description, let explicit, let totalEpisodes, let href):
//    return DetailTypes.shows(description: description,
//                             explicit: explicit,
//                             numberOfEpisodes:
//                             totalEpisodes,
//                             href: href)
//
//  case .tracks(let popularity, let explicit, let durationInMs, let href):
//    return DetailTypes.tracks(popularity: popularity,
//                              explicit: explicit,
//                              durationInMs: durationInMs,
//                              href: href)
//
//  case .playlists(let description, let playlistTracks, let mediaOwner, let href):
//    return DetailTypes.playlists(description: description,
//                                 playlistTracks: playlistTracks,
//                                 mediaOwner: mediaOwner,
//                                 href: href)
//
//  case .artists(let followers, let genres, let popularity, let href):
//    return DetailTypes.artists(followers: followers,
//                               genres: genres,
//                               popularity: popularity,
//                               href: href)
//  case .album(let numberOfTracks, let href):
//    return DetailTypes.album(numberOfTracks: numberOfTracks,
//                             href: href)

  // MARK: - Sub structs

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
    var durationInMs: Int
    var href: String
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
    var numberOfTracks: Int
    var href: String
  }



  struct PlaylistTracks {
    var href: String
    var numberOfSongs: Int
  }

  struct MediaOwner {
    var href: String
    var displayName: String
  }

}
