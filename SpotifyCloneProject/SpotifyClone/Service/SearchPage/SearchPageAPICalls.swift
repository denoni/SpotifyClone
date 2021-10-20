//
//  SearchPageAPICalls.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/20/21.
//

import Foundation
import Alamofire

class SearchPageAPICalls: ObservableObject {

  func search(for searchTerm: String, accessToken: String,
              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    // Do not separate with spaces.
    let limit = 5
    let type = "track,playlist,album,artist,show,episode"
    let baseUrl = "https://api.spotify.com/v1/search?q=\(searchTerm)&type=\(type)&limit=\(limit)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    var mediaItems = [SpotifyModel.MediaItem]()

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: SearchEndpointResponse.self) { response in

        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        if data.tracks != nil {
          parseTracks(response.value!.tracks!)
        }

        if data.playlists != nil {
          parsePlaylists(response.value!.playlists!)
        }

        if data.albums != nil {
          parseAlbums(response.value!.albums!)
        }

        if data.artists != nil {
          parseArtists(response.value!.artists!)
        }

        if data.shows != nil {
          parseShows(response.value!.shows!)
        }

        if data.episodes != nil {
          parseEpisodes(response.value!.episodes!)
        }

      }



    // MARK: - Tracks
    func parseTracks(_ data: SearchEndpointResponse.TrackSearchResponse) {

      let numberOfTracks = data.items.count

      // TODO: Handle empty responses in a better way
      guard numberOfTracks != 0 else {
        completionHandler(mediaItems)
        print("The API response was corrects but empty. We'll just return []")
        return
      }

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

        let trackItem = SpotifyModel
          .MediaItem(title: title,
                     previewURL: previewURL ?? "",
                     imageURL: imageURL ?? "",
                     authorName: authorName,
                     author: author,
                     mediaType: .track,
                     id: id,
                     details: SpotifyModel.DetailTypes.tracks(
                      trackDetails: SpotifyModel.TrackDetails(popularity: popularity ?? 0,
                                                              explicit: explicit,
                                                              durationInMs: durationInMs,
                                                              id: id,
                                                              album: SpotifyModel.AlbumDetails(name: albumName ?? "",
                                                                                               numberOfTracks: numberOfTracks ?? 0,
                                                                                               releaseDate: releaseDate ?? "0",
                                                                                               id: albumID ?? ""))))
        mediaItems.append(trackItem)
      }
      completionHandler(mediaItems)
    }

    // MARK: - Playlists
    func parsePlaylists(_ data: SearchEndpointResponse.PlaylistSearchResponse) {

      let numberOfPlaylists = data.items.count

      // TODO: Handle empty responses in a better way
      guard numberOfPlaylists != 0 else {
        completionHandler(mediaItems)
        print("The API response was corrects but empty. We'll just return []")
        return
      }

      for playlistIndex in 0 ..< numberOfPlaylists {
        let playlist = data.items[playlistIndex]

        let title = playlist.name
        let imageURL = playlist.images[0].url
        let id = playlist.id

        let description = playlist.description
        let playlistTracks = playlist.tracks
        let mediaOwner = playlist.owner

        let playlistItem = SpotifyModel.MediaItem(title: title,
                                                  previewURL: "",
                                                  imageURL: imageURL,
                                                  authorName: [mediaOwner.display_name],
                                                  mediaType: .playlist,
                                                  id: id,
                                                  details: SpotifyModel.DetailTypes.playlists(
                                                    playlistDetails: SpotifyModel.PlaylistDetails(description: description,
                                                                                                  playlistTracks: SpotifyModel.PlaylistTracks(numberOfSongs: playlistTracks.total,
                                                                                                                                              href: playlistTracks.href),
                                                                                                  owner: SpotifyModel.MediaOwner(displayName: mediaOwner.display_name,
                                                                                                                                 id: mediaOwner.id),
                                                                                                  id: id)))
        mediaItems.append(playlistItem)
      }
      completionHandler(mediaItems)
    }

    // MARK: - Playlists
    func parseAlbums(_ data: SearchEndpointResponse.AlbumSearchResponse) {

      let numberOfAlbums = data.items.count

      // TODO: Handle empty responses in a better way
      guard numberOfAlbums != 0 else {
        completionHandler(mediaItems)
        print("The API response was corrects but empty. We'll just return []")
        return
      }

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

        let albumItem = SpotifyModel.MediaItem(title: title,
                                               previewURL: "",
                                               imageURL: imageURL ?? "",
                                               authorName: authorName,
                                               author: author,
                                               mediaType: .album,
                                               id: id,
                                               details: SpotifyModel.DetailTypes.album(albumDetails: SpotifyModel.AlbumDetails(name: title,
                                                                                                                               numberOfTracks: numberOfTracks,
                                                                                                                               releaseDate: releaseDate,
                                                                                                                               id: albumID)))

        mediaItems.append(albumItem)
      }
      completionHandler(mediaItems)
    }

    // MARK: - Artists
    func parseArtists(_ data: SearchEndpointResponse.ArtistSearchResponse) {

      let numberOfArtists = data.items.count

      // TODO: Handle empty responses in a better way
      guard numberOfArtists != 0 else {
        completionHandler(mediaItems)
        print("The API response was corrects but empty. We'll just return []")
        return
      }

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
          return "" // TODO: Return a avatar placeholder image
        }

        let artistItem = SpotifyModel.MediaItem(title: title,
                                                previewURL: "",
                                                imageURL: imageURL,
                                                authorName: [title],
                                                mediaType: .artist,
                                                id: id,
                                                details: SpotifyModel.DetailTypes.artists(artistDetails: SpotifyModel.ArtistDetails(followers: followers,
                                                                                                                                    genres: genres!,
                                                                                                                                    popularity: popularity!,
                                                                                                                                    id: id)))
        mediaItems.append(artistItem)
      }
      completionHandler(mediaItems)
    }

    // MARK: - Shows
    func parseShows(_ data: SearchEndpointResponse.ShowSearchResponse) {

      let numberOfShows = data.items.count

      // TODO: Handle empty responses in a better way
      guard numberOfShows != 0 else {
        completionHandler(mediaItems)
        print("The API response was corrects but empty. We'll just return []")
        return
      }

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

        let showItem = SpotifyModel.MediaItem(title: title,
                                              previewURL: "",
                                              imageURL: imageURL,
                                              authorName: [authorName],
                                              mediaType: .show,
                                              id: id,
                                              details: SpotifyModel.DetailTypes.shows(showDetails: SpotifyModel.ShowDetails(description: description,
                                                                                                                               explicit: explicit,
                                                                                                                               numberOfEpisodes: numberOfEpisodes,
                                                                                                                               id: showID)))
        mediaItems.append(showItem)
      }
      completionHandler(mediaItems)
    }

    // MARK: - Episodes
    func parseEpisodes(_ data: SearchEndpointResponse.EpisodesSearchResponse) {

      let numberOfEpisodes = data.items.count

      // TODO: Handle empty responses in a better way
      guard numberOfEpisodes != 0 else {
        completionHandler(mediaItems)
        print("The API response was corrects but empty. We'll just return []")
        return
      }

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


        let episodeItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: audioPreview,
                                                 imageURL: imageURL,
                                                 authorName: [""],
                                                 mediaType: .episode,
                                                 id: id,

                                                 details: SpotifyModel.DetailTypes.episode(episodeDetails: SpotifyModel.EpisodeDetails(explicit: explicit,
                                                                                                                                       description: description,
                                                                                                                                       durationInMs: durationInMs,
                                                                                                                                       releaseDate: releaseDate,
                                                                                                                                       id: id)))
        mediaItems.append(episodeItem)
      }
      completionHandler(mediaItems)
    }

  }










  // TODO: Separate this func into a different file

  func getPlaylists(accessToken: String,
                    completionHandler: @escaping ([SpotifyModel.PlaylistItem]) -> Void) {

    let country = "US"
    let limit = 10

    let baseUrl = "https://api.spotify.com/v1/browse/featured-playlists?country=\(country)&limit=\(limit)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: PlaylistResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving playlists from API.")
        }

        let numberOfPlaylists = data.playlists.items.count

        var playlists = [SpotifyModel.PlaylistItem]()

        guard numberOfPlaylists != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        for index in 0 ..< numberOfPlaylists {
          let sectionTitle = data.message
          let name = data.playlists.items[index].name
          let imageURL = data.playlists.items[index].images[0].url
          let id = data.playlists.items[index].id

          let playlistItem = SpotifyModel.PlaylistItem(sectionTitle: sectionTitle ?? "Playlist",
                                                       name: name,
                                                       imageURL: imageURL,
                                                       id: id)
          playlists.append(playlistItem)
        }
        completionHandler(playlists)
      }

  }

}
