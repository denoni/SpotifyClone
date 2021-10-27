//
//  MediaDetailSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/17/21.
//

import Foundation

enum MediaDetailSection: Hashable {
  case artist(_ artistSection: ArtistSections)
  case playlist(_ playlistSection: PlaylistSections)
  case album(_ albumSection: AlbumSections)
  case shows(_ showSection: ShowsSections)
  case episodes(_ episodeSection: EpisodeSections)
  case artistBasicInfo(_ artistBasicSection: ArtistBasicInfo)
  case userLikedFollowedMedia(_ userLikedFollowedMedia: UserLikedFollowedMedia)

  enum ArtistSections: CaseIterable, MediaDetailSectionsProtocol {
    case topTracksFromArtist
    case albumsFromArtist
    case playlistsFromArtist
  }

  enum PlaylistSections: CaseIterable, MediaDetailSectionsProtocol {
    case tracksFromPlaylist
  }

  enum AlbumSections: CaseIterable, MediaDetailSectionsProtocol {
    case tracksFromAlbum
  }

  enum ShowsSections: CaseIterable, MediaDetailSectionsProtocol {
    case episodesFromShow
  }

  enum EpisodeSections: CaseIterable, MediaDetailSectionsProtocol {
    case episodeDetails
  }

  enum ArtistBasicInfo: CaseIterable, MediaDetailSectionsProtocol {
    case artistBasicInfo
  }

  enum UserLikedFollowedMedia: CaseIterable, MediaDetailSectionsProtocol {
    case userLikedSongs
    case userSavedEpisodes
  }
}
