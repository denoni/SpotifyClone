//
//  MediaDetailAPICalls.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/18/21.
//

import Foundation

struct MediaDetailAPICalls {

  struct ArtistAPICalls {

    static func getTopTracksFromArtist(mediaDetailVM: MediaDetailViewModel) {
      mediaDetailVM.api.getTopTracksFromArtist(with: mediaDetailVM.accessToken!,
                                               artistID: mediaDetailVM.mainItem!.id) { tracks in

        mediaDetailVM.trimAndCommunicateResult(medias: tracks, section: .artist(.topTracksFromArtist),
                                               limit: 5, deleteAlmostDuplicateResults: true)
      }
    }

    static func getAlbumsFromArtist(mediaDetailVM: MediaDetailViewModel) {
      mediaDetailVM.api.getAlbumsFromArtist(with: mediaDetailVM.accessToken!,
                                            artistID: mediaDetailVM.mainItem!.id) { albums in

        mediaDetailVM.trimAndCommunicateResult(medias: albums, section: .artist(.albumsFromArtist),
                                               limit: 5, deleteAlmostDuplicateResults: true)
      }
    }

    static func getPlaylistFromArtist(mediaDetailVM: MediaDetailViewModel) {
      // Remote special characters artist title(name)
      let keyWord: String = mediaDetailVM.mainItem!.title.folding(options: .diacriticInsensitive, locale: .current)

      mediaDetailVM.api.getPlaylistsFromArtist(with: mediaDetailVM.accessToken!, keyWord: keyWord) { playlists in

        mediaDetailVM.trimAndCommunicateResult(medias: playlists, section: .artist(.playlistsFromArtist),
                                               deleteAlmostDuplicateResults: true)
      }
    }

  }

  struct PlaylistAPICalls {

    static func getTracksFromPlaylist(mediaDetailVM: MediaDetailViewModel,
                                      loadMoreEnabled: Bool = false) {
      let offset = mediaDetailVM.getNumberOfLoadedItems(for: .playlist(.tracksFromPlaylist))
      mediaDetailVM.increaseNumberOfLoadedItems(for: .playlist(.tracksFromPlaylist), by: 10)

      let playlistID = SpotifyModel.getPlaylistDetails(for: mediaDetailVM.mainItem!).id

      mediaDetailVM.api.getTracksFromPlaylist(with: mediaDetailVM.accessToken!,
                                              playlistID: playlistID,
                                              offset: offset) { tracks in

        mediaDetailVM.trimAndCommunicateResult(medias: tracks,
                                               section: .playlist(.tracksFromPlaylist),
                                               loadMoreEnabled: loadMoreEnabled)
      }
    }

  }

  struct AlbumAPICalls {

    static func getTracksFromAlbum(mediaDetailVM: MediaDetailViewModel,
                                   loadMoreEnabled: Bool = false) {
      let offset = mediaDetailVM.getNumberOfLoadedItems(for: .album(.tracksFromAlbum))
      mediaDetailVM.increaseNumberOfLoadedItems(for: .album(.tracksFromAlbum), by: 10)

      mediaDetailVM.api.getTracksFromAlbum(with: mediaDetailVM.accessToken!,
                                           albumID: SpotifyModel.getAlbumDetails(for: mediaDetailVM.mainItem!).id,
                                           offset: offset) { tracks in
        mediaDetailVM.trimAndCommunicateResult(medias: tracks, section: .album(.tracksFromAlbum),
                                               loadMoreEnabled: loadMoreEnabled)
      }
    }

  }

  struct ShowsAPICalls {

    static func getEpisodesFromShows(mediaDetailVM: MediaDetailViewModel,
                                     loadMoreEnabled: Bool = false) {
      let offset = mediaDetailVM.getNumberOfLoadedItems(for: .shows(.episodesFromShow))
      mediaDetailVM.increaseNumberOfLoadedItems(for: .shows(.episodesFromShow), by: 10)

      mediaDetailVM.api.getEpisodesFromShow(with: mediaDetailVM.accessToken!,
                                            showID: SpotifyModel.getShowDetails(for: mediaDetailVM.mainItem!).id,
                                            offset: offset) { episodes in

        mediaDetailVM.trimAndCommunicateResult(medias: episodes, section: .shows(.episodesFromShow),
                                               loadMoreEnabled: loadMoreEnabled)
      }
    }

  }

  struct EpisodeAPICalls {

    static func getEpisodeDetails(mediaDetailVM: MediaDetailViewModel,
                                  loadMoreEnabled: Bool = false) {
      mediaDetailVM.api.getEpisodeDetails(with: mediaDetailVM.accessToken!,
                                          episodeID: mediaDetailVM.mainItem!.id) { episode in

        mediaDetailVM.trimAndCommunicateResult(medias: [episode], section: .episodes(.episodeDetails))
      }
    }
  }

  struct UserInfoAPICalls {
    static func checksIfUserFollows(_ mediaType: APIFetchingUserInfo.ValidMediaType,
                                    mediaDetailVM: MediaDetailViewModel,
                                    itemID: String) {
      mediaDetailVM.api.checksIfUserFollows(mediaType, with: mediaDetailVM.accessToken!, mediaID: itemID) { response in
        if response == true {
          mediaDetailVM.followedIDs[itemID] = .isFollowing
        } else {
          mediaDetailVM.followedIDs[itemID] = .isNotFollowing
        }

        // Now we already checked is user follows, so `artistBasicInfo` is not loading anymore
        mediaDetailVM.artistBasicInfoAlreadyLoaded()
      }
    }

    static func changeFollowingState(to followingState: APIFetchingUserInfo.FollowingState,
                                     in mediaType: APIFetchingUserInfo.ValidMediaType,
                                     mediaDetailVM: MediaDetailViewModel,
                                     itemID: String) {
      mediaDetailVM.api.changeFollowingState(to: followingState,
                                             in: mediaType,
                                             with: mediaDetailVM.accessToken!,
                                             mediaID: itemID) { errorOccurred in
        if !errorOccurred {
          if followingState == .follow {
            mediaDetailVM.followedIDs[itemID] = .isFollowing
          } else {
            mediaDetailVM.followedIDs[itemID] = .isNotFollowing
          }
        } else {
          mediaDetailVM.followedIDs[itemID] = .error
        }
      }
    }

    // Gets the artist basic info(followers, popularity, profile image -> we're mainly interested in the image)
    static func getArtistBasicInfo(mediaDetailVM: MediaDetailViewModel) {
      var artistIDs = [String]()
      for index in mediaDetailVM.mainItem!.author!.indices {
        artistIDs.append(mediaDetailVM.mainItem!.author![index].id)
      }

      mediaDetailVM.api.basicInfoAPI.getArtists(with: mediaDetailVM.accessToken!, artistIDs: artistIDs) { artists in
        mediaDetailVM.trimAndCommunicateResult(medias: artists, section: .artistBasicInfo(.artistBasicInfo))
      }
    }
  }

  struct UserLikedFollowedMediaAPICalls {
    static func getLikedSongs(mediaDetailVM: MediaDetailViewModel) {
      let offset = mediaDetailVM.getNumberOfLoadedItems(for: .userLikedFollowedMedia(.userLikedSongs))
      mediaDetailVM.increaseNumberOfLoadedItems(for: .userLikedFollowedMedia(.userLikedSongs), by: 10)

      mediaDetailVM.api.trackAPI.getTrack(using: .userLikedTracks,
                                          with: mediaDetailVM.accessToken!,
                                          limit: 10,
                                          offset: offset) { tracks in

        mediaDetailVM.trimAndCommunicateResult(medias: tracks,
                                               section: .userLikedFollowedMedia(.userLikedSongs),
                                               loadMoreEnabled: true)
      }
    }

    static func getUserSavedEpisodes(mediaDetailVM: MediaDetailViewModel) {
      let offset = mediaDetailVM.getNumberOfLoadedItems(for: .userLikedFollowedMedia(.userSavedEpisodes))
      mediaDetailVM.increaseNumberOfLoadedItems(for: .userLikedFollowedMedia(.userSavedEpisodes), by: 10)

      mediaDetailVM.api.episodeAPI.getEpisode(using: .userSavedEpisodes,
                                              with: mediaDetailVM.accessToken!,
                                              limit: 10,
                                              offset: offset) { episodes in

        mediaDetailVM.trimAndCommunicateResult(medias: episodes,
                                               section: .userLikedFollowedMedia(.userSavedEpisodes),
                                               loadMoreEnabled: true)
      }
    }
  }

  struct UserLibraryInfoAPICalls {
    static func getNumberOfLikedSongs(mediaDetailVM: MediaDetailViewModel) {
      mediaDetailVM.api.userLibraryInfoAPI.getNumberOfLikedSongs(with: mediaDetailVM.accessToken!) { response in
        mediaDetailVM.userLibraryInfo[.numberOfLikedSongs] = response
      }
    }

    static func getNumberOfSavedEpisodes(mediaDetailVM: MediaDetailViewModel) {
      mediaDetailVM.api.userLibraryInfoAPI.getNumberOfSavedEpisodes(with: mediaDetailVM.accessToken!) { response in
        mediaDetailVM.userLibraryInfo[.numberOfSavedEpisodes] = response
      }
    }
  }

}
