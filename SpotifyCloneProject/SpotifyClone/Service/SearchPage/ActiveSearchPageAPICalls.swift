//
//  ActiveSearchPageAPICalls.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/20/21.
//

import Foundation
import Alamofire

class ActiveSearchPageAPICalls: ObservableObject {

  func search(for searchTerm: String, accessToken: String,
              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    // Do not separate with spaces.
    let limit = 5
    let type = "track,playlist,album,artist,show,episode"
    let baseUrl = "https://api.spotify.com/v1/search?q=\(searchTerm)&type=\(type)&limit=\(limit)"

    let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

    var mediaItems = [SpotifyModel.MediaItem]()

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: SearchEndpointResponse.self) { response in

        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        if data.tracks != nil { mediaItems += self.parseTracks(response.value!.tracks!) }
        if data.playlists != nil { mediaItems += self.parsePlaylists(response.value!.playlists!) }
        if data.albums != nil { mediaItems += self.parseAlbums(response.value!.albums!) }
        if data.artists != nil { mediaItems += self.parseArtists(response.value!.artists!) }
        if data.shows != nil { mediaItems += self.parseShows(response.value!.shows!) }
        if data.episodes != nil { mediaItems += self.parseEpisodes(response.value!.episodes!) }

        if mediaItems.count == 0 {
          print("The API response was corrects but empty. We'll just return []")
        }

        completionHandler(mediaItems)
      }
  }

  // MARK: - Tracks
  fileprivate func parseTracks(_ data: SearchEndpointResponse.TrackSearchResponse) -> [SpotifyModel.MediaItem] {

    let numberOfTracks = data.items.count
    var trackItems = [SpotifyModel.MediaItem]()

    for trackIndex in 0 ..< numberOfTracks {
      let track = data.items[trackIndex]

      let title = track.name
      let previewURL = track.preview_url
      let author = track.artists
      let id = track.id
      var authorName = [String]()

      let popularity = track.popularity
      let explicit = track.explicit
      let durationInMs = track.duration_ms

      let imageURL = track.album?.images?[0].url
      let albumName = track.album?.name
      let albumID = track.album?.id
      let numberOfTracks = track.album?.total_tracks
      let releaseDate = track.album?.release_date

      for artistIndex in track.artists.indices {
        authorName.append(track.artists[artistIndex].name)
      }

      let trackDetails = SpotifyModel.TrackDetails(popularity: popularity ?? 0,
                                                   explicit: explicit,
                                                   durationInMs: durationInMs,
                                                   id: id,
                                                   album: SpotifyModel.AlbumDetails(name: albumName ?? "",
                                                                                    numberOfTracks: numberOfTracks ?? 0,
                                                                                    releaseDate: releaseDate ?? "0",
                                                                                    id: albumID ?? ""))

      let trackItem = SpotifyModel.MediaItem(title: title, previewURL: previewURL ?? "", imageURL: imageURL ?? "",
                                             authorName: authorName, author: author, mediaType: .track, id: id,
                                             details: SpotifyModel.DetailTypes.tracks(trackDetails: trackDetails))

      trackItems.append(trackItem)
    }
    return trackItems
  }

  // MARK: - Playlists
  fileprivate func parsePlaylists(_ data: SearchEndpointResponse.PlaylistSearchResponse) -> [SpotifyModel.MediaItem] {

    let numberOfPlaylists = data.items.count
    var playlistItems = [SpotifyModel.MediaItem]()

    for playlistIndex in 0 ..< numberOfPlaylists {
      let playlist = data.items[playlistIndex]

      let title = playlist.name
      let imageURL = playlist.images[0].url
      let id = playlist.id

      let description = playlist.description
      let playlistTracks = playlist.tracks
      let mediaOwner = playlist.owner

      let infoAboutTracksInPlaylist = SpotifyModel.PlaylistTracks(numberOfSongs: playlistTracks.total, href: playlistTracks.href)
      let playlistOwner = SpotifyModel.MediaOwner(displayName: mediaOwner.display_name, id: mediaOwner.id)
      let playlistDetails = SpotifyModel.PlaylistDetails(description: description,
                                                         playlistTracks: infoAboutTracksInPlaylist,
                                                         owner: playlistOwner,
                                                         id: id)

      let playlistItem = SpotifyModel.MediaItem(title: title,
                                                previewURL: "",
                                                imageURL: imageURL,
                                                authorName: [mediaOwner.display_name],
                                                mediaType: .playlist,
                                                id: id,
                                                details: SpotifyModel.DetailTypes.playlists(
                                                  playlistDetails: playlistDetails))

      playlistItems.append(playlistItem)
    }
    return playlistItems
  }

  // MARK: - Playlists
  fileprivate func parseAlbums(_ data: SearchEndpointResponse.AlbumSearchResponse) -> [SpotifyModel.MediaItem] {

    let numberOfAlbums = data.items.count
    var albumItems = [SpotifyModel.MediaItem]()

    for albumIndex in 0 ..< numberOfAlbums {
      let album = data.items[albumIndex]

      let title = album.name
      let imageURL = album.images?[0].url
      let author = album.artists
      let id = album.id
      var authorName = [String]()

      let albumID = album.id
      let numberOfTracks = album.total_tracks
      let releaseDate = album.release_date

      for artistIndex in album.artists.indices {
        authorName.append(album.artists[artistIndex].name)
      }

      let albumDetails = SpotifyModel.AlbumDetails(name: title, numberOfTracks: numberOfTracks,
                                                   releaseDate: releaseDate, id: albumID)

      let albumItem = SpotifyModel.MediaItem(title: title, previewURL: "", imageURL: imageURL ?? "",
                                             authorName: authorName, author: author, mediaType: .album, id: id,
                                             details: SpotifyModel.DetailTypes.album(albumDetails: albumDetails))

      albumItems.append(albumItem)
    }
    return albumItems
  }

  // MARK: - Artists
  fileprivate func parseArtists(_ data: SearchEndpointResponse.ArtistSearchResponse) -> [SpotifyModel.MediaItem] {

    let numberOfArtists = data.items.count
    var artistItems = [SpotifyModel.MediaItem]()

    for artistIndex in 0 ..< numberOfArtists {
      let artist = data.items[artistIndex]

      let title = artist.name
      let id = artist.id

      let followers = artist.followers!.total
      let genres = artist.genres
      let popularity = artist.popularity

      var imageURL: String {
        if artist.images != nil {
          return artist.images!.count > 0 ? artist.images![0].url : ""
        }
        return ""
      }

      let artistDetails = SpotifyModel.ArtistDetails(followers: followers, genres: genres!,
                                                     popularity: popularity!, id: id)

      let artistItem = SpotifyModel.MediaItem(title: title, previewURL: "", imageURL: imageURL,
                                              authorName: [title], mediaType: .artist, id: id,
                                              details: SpotifyModel.DetailTypes.artists(artistDetails: artistDetails))
      artistItems.append(artistItem)
    }
    return artistItems
  }

  // MARK: - Shows
  fileprivate func parseShows(_ data: SearchEndpointResponse.ShowSearchResponse) -> [SpotifyModel.MediaItem] {

    let numberOfShows = data.items.count
    var showItems = [SpotifyModel.MediaItem]()

    for showIndex in 0 ..< numberOfShows {
      let show = data.items[showIndex]

      let title = show.name
      let imageURL = show.images[0].url
      let authorName = show.publisher
      let id = show.id

      let description = show.description
      let explicit = show.explicit
      let showID = show.id
      let numberOfEpisodes = show.total_episodes

      let showDetails = SpotifyModel.ShowDetails(description: description, explicit: explicit,
                                                 numberOfEpisodes: numberOfEpisodes, id: showID)

      let showItem = SpotifyModel.MediaItem(title: title, previewURL: "", imageURL: imageURL,
                                            authorName: [authorName], mediaType: .show, id: id,
                                            details: SpotifyModel.DetailTypes.shows(showDetails: showDetails))
      showItems.append(showItem)
    }
    return showItems
  }

  // MARK: - Episodes
  fileprivate func parseEpisodes(_ data: SearchEndpointResponse.EpisodesSearchResponse) -> [SpotifyModel.MediaItem] {

    let numberOfEpisodes = data.items.count
    var episodeItems = [SpotifyModel.MediaItem]()

    for episodeIndex in 0 ..< numberOfEpisodes {
      let episode = data.items[episodeIndex]

      let title = episode.name
      let imageURL = episode.images[0].url
      let audioPreview = episode.audio_preview_url
      let id = episode.id

      let description = episode.description
      let explicit = episode.explicit
      let durationInMs = episode.duration_ms
      let releaseDate = episode.release_date

      let episodeDetails = SpotifyModel.EpisodeDetails(explicit: explicit, description: description,
                                                       durationInMs: durationInMs, releaseDate: releaseDate, id: id)

      let episodeItem = SpotifyModel.MediaItem(title: title,
                                               previewURL: audioPreview,
                                               imageURL: imageURL,
                                               authorName: [""],
                                               mediaType: .episode,
                                               id: id,

                                               details: SpotifyModel.DetailTypes.episode(episodeDetails: episodeDetails))
      episodeItems.append(episodeItem)
    }
    return episodeItems
  }
}
