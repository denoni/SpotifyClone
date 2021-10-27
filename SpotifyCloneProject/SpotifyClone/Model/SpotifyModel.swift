//
//  SpotifyModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import Foundation

struct SpotifyModel {

  struct CurrentUserProfileInfo {
    let displayName: String
    let followers: Int
    let imageURL: String
    let id: String
  }

  enum MediaTypes {
    case track
    case album
    case playlist
    case show
    case artist
    case episode
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
    var lowResImageURL: String?
    var authorName: [String]
    var author: [Artist]?
    var mediaType: MediaTypes
    var id: String
    var details: DetailTypes

    fileprivate func getDetails() -> DetailTypes {
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

      case .episode(let episodeDetails):
        return DetailTypes.episode(episodeDetails: episodeDetails)
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
    case episode(episodeDetails: EpisodeDetails)
  }

  struct ShowDetails {
    var description: String
    var explicit: Bool
    var numberOfEpisodes: Int
    var id: String
  }

  struct TrackDetails {
    var popularity: Int
    var explicit: Bool
    var description: String?
    var durationInMs: Double
    var id: String
    var album: AlbumDetails?
  }

  struct PlaylistDetails {
    var description: String
    var playlistTracks: PlaylistTracks
    var owner: MediaOwner
    var id: String
  }

  struct ArtistDetails {
    var followers: Int
    var genres: [String]
    var popularity: Int
    var id: String
  }

  struct AlbumDetails {
    var name: String
    var numberOfTracks: Int
    var releaseDate: String // yyyy-MM-dd
    var id: String
  }

  struct EpisodeDetails {
    var explicit: Bool
    var description: String?
    var durationInMs: Double
    var releaseDate: String
    var id: String
    var showId: String?
  }

  // MARK: - Sub structs
  struct PlaylistTracks {
    var numberOfSongs: Int
    var href: String // Can't use id because some responses only return href
  }

  struct MediaOwner {
    var displayName: String
    var id: String
  }

  // MARK: - Auxiliary functions

  static func getShowDetails(for mediaItem: MediaItem) -> ShowDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .shows(let showDetails):
      return SpotifyModel.ShowDetails(description: showDetails.description,
                                      explicit: showDetails.explicit,
                                      numberOfEpisodes: showDetails.numberOfEpisodes,
                                      id: showDetails.id)
    default:
      fatalError("Wrong type for `ShowDetails`")
    }
  }

  static func getTrackDetails(for mediaItem: MediaItem) -> TrackDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .tracks(let trackDetails):
      return SpotifyModel.TrackDetails(popularity: trackDetails.popularity,
                                       explicit: trackDetails.explicit,
                                       durationInMs: trackDetails.durationInMs,
                                       id: trackDetails.id,
                                       album: trackDetails.album)
    default:
      fatalError("Wrong type for `TrackDetails`")
    }
  }

  static func getPlaylistDetails(for mediaItem: MediaItem) -> PlaylistDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .playlists(let playlistDetails):
      return SpotifyModel.PlaylistDetails(description: playlistDetails.description,
                                          playlistTracks: playlistDetails.playlistTracks,
                                          owner: playlistDetails.owner,
                                          id: playlistDetails.id)
    default:
      fatalError("Wrong type for `PlaylistDetails`")
    }
  }

  static func getArtistDetails(for mediaItem: MediaItem) -> ArtistDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .artists(let artistDetails):
      return SpotifyModel.ArtistDetails(followers: artistDetails.followers,
                                        genres: artistDetails.genres,
                                        popularity: artistDetails.popularity,
                                        id: artistDetails.id)
    default:
      fatalError("Wrong type for `ArtistDetails`")
    }
  }

  static func getAlbumDetails(for mediaItem: MediaItem) -> AlbumDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .album(let albumDetails):
      return SpotifyModel.AlbumDetails(name: albumDetails.name,
                                       numberOfTracks: albumDetails.numberOfTracks,
                                       releaseDate: albumDetails.releaseDate,
                                       id: albumDetails.id)
    default:
      fatalError("Wrong type for `AlbumDetails`")
    }
  }

  static func getEpisodeDetails(for mediaItem: MediaItem) -> EpisodeDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .episode(let episodeDetails):
      return SpotifyModel.EpisodeDetails(explicit: episodeDetails.explicit,
                                         description: episodeDetails.description,
                                         durationInMs: episodeDetails.durationInMs,
                                         releaseDate: episodeDetails.releaseDate,
                                         id: episodeDetails.id)
    default:
      fatalError("Wrong type for `EpisodeDetails`")
    }
  }

}
