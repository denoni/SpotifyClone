//
//  MediaDetailAPICalls.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/18/21.
//

import Foundation

struct MediaDetailAPICalls {

  struct ArtistAPICalls {

    static func getTopTracksFromArtist(mediaVM: MediaDetailViewModel) {
      mediaVM.api.getTopTracksFromArtist(with: mediaVM.accessToken!, artistID: mediaVM.mainItem!.id) { tracks in
        mediaVM.trimAndCommunicateResult(medias: tracks, section: .artist(.topTracksFromArtist), limit: 5)
      }
    }

    static func getAlbumsFromArtist(mediaVM: MediaDetailViewModel) {
      mediaVM.api.getAlbumsFromArtist(with: mediaVM.accessToken!, artistID: mediaVM.mainItem!.id) { albums in
        mediaVM.trimAndCommunicateResult(medias: albums, section: .artist(.albumsFromArtist), limit: 5)
      }
    }

    static func getPlaylistFromArtist(mediaVM: MediaDetailViewModel) {
      // Remote special characters artist title(name)
      let keyWord: String = mediaVM.mainItem!.title.folding(options: .diacriticInsensitive, locale: .current)

      mediaVM.api.getPlaylistsFromArtist(with: mediaVM.accessToken!, keyWord: keyWord) { playlists in
        mediaVM.trimAndCommunicateResult(medias: playlists, section: .artist(.playlistsFromArtist))
      }
    }

  }


  struct PlaylistAPICalls {

    static func getTracksFromPlaylist(mediaVM: MediaDetailViewModel,
                                      loadMoreEnabled: Bool = false) {
      let offset = mediaVM.getNumberOfLoadedItems(for: .playlist(.tracksFromPlaylist))
      mediaVM.increaseNumberOfLoadedItems(for: .playlist(.tracksFromPlaylist), by: 10)

      mediaVM.api.getTracksFromPlaylist(with: mediaVM.accessToken!,
                                        playlistID: SpotifyModel.getPlaylistDetails(for: mediaVM.mainItem!).id,
                                        offset: offset) { tracks in
        mediaVM.trimAndCommunicateResult(medias: tracks, section: .playlist(.tracksFromPlaylist), loadMoreEnabled: loadMoreEnabled)
      }
    }

  }


  struct AlbumAPICalls {

    static func getTracksFromAlbum(mediaVM: MediaDetailViewModel,
                                   loadMoreEnabled: Bool = false) {
      let offset = mediaVM.getNumberOfLoadedItems(for: .album(.tracksFromAlbum))
      mediaVM.increaseNumberOfLoadedItems(for: .album(.tracksFromAlbum), by: 10)

      mediaVM.api.getTracksFromAlbum(with: mediaVM.accessToken!,
                                     albumID: SpotifyModel.getAlbumDetails(for: mediaVM.mainItem!).id,
                                     offset: offset) { tracks in
        mediaVM.trimAndCommunicateResult(medias: tracks, section: .album(.tracksFromAlbum),
                                         loadMoreEnabled: loadMoreEnabled)
      }
    }

  }


  struct ShowsAPICalls {

    static func getEpisodesFromShows(mediaVM: MediaDetailViewModel,
                                     loadMoreEnabled: Bool = false) {
      let offset = mediaVM.getNumberOfLoadedItems(for: .shows(.episodesFromShow))
      mediaVM.increaseNumberOfLoadedItems(for: .shows(.episodesFromShow), by: 10)

      mediaVM.api.getEpisodesFromShow(with: mediaVM.accessToken!,
                                      showID: SpotifyModel.getShowDetails(for: mediaVM.mainItem!).id,
                                      offset: offset) { episodes in
        mediaVM.trimAndCommunicateResult(medias: episodes, section: .shows(.episodesFromShow),
                                         loadMoreEnabled: loadMoreEnabled)
      }
    }

  }


  struct EpisodeAPICalls {

    static func getEpisodeDetails(mediaVM: MediaDetailViewModel,
                                  loadMoreEnabled: Bool = false) {
      mediaVM.api.getEpisodeDetails(with: mediaVM.accessToken!, episodeID: mediaVM.mainItem!.id) { episode in
        mediaVM.trimAndCommunicateResult(medias: [episode], section: .episodes(.episodeDetails))
      }
    }
  }


  struct UserInfoAPICalls {
    static func checksIfUserFollows(_ mediaType: APIFetchingUserInfo.ValidMediaType,
                                    mediaVM: MediaDetailViewModel,
                                    itemID: String) {
      mediaVM.api.checksIfUserFollows(mediaType, with: mediaVM.accessToken!, mediaID: itemID) { response in
        if response == true {
          mediaVM.followedIDs[itemID] = .isFollowing
        } else {
          mediaVM.followedIDs[itemID] = .isNotFollowing
        }

        // Now we already checked is user follows, so `artistBasicInfo` is not loading anymore
        mediaVM.artistBasicInfoAlreadyLoaded()
      }
    }

    static func changeFollowingState(to followingState: APIFetchingUserInfo.FollowingState,
                                     in mediaType: APIFetchingUserInfo.ValidMediaType,
                                     mediaVM: MediaDetailViewModel,
                                     itemID: String) {
      mediaVM.api.changeFollowingState(to: followingState, in: mediaType, with: mediaVM.accessToken!, mediaID: itemID) { errorOccurred in
        if !errorOccurred {
          if followingState == .follow {
            mediaVM.followedIDs[itemID] = .isFollowing
          } else {
            mediaVM.followedIDs[itemID] = .isNotFollowing
          }
        } else {
          mediaVM.followedIDs[itemID] = .error
        }
      }
    }

    // Gets the artist basic info(followers, popularity, profile image -> we're mainly interested in the image)
    static func getArtistBasicInfo(mediaVM: MediaDetailViewModel) {
      var artistIDs = [String]()
      for index in mediaVM.mainItem!.author!.indices {
        artistIDs.append(mediaVM.mainItem!.author![index].id)
      }

      mediaVM.api.basicInfoAPI.getArtists(with: mediaVM.accessToken!, artistIDs: artistIDs) { artists in
        mediaVM.trimAndCommunicateResult(medias: artists, section: .artistBasicInfo(.artistBasicInfo))
      }
    }
  }

}
