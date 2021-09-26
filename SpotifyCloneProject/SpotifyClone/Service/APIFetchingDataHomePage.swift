//
//  APIFetchingData.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation
import Alamofire

// TODO: Handle empty responses and errors
// TODO: The data received after decoding should be easier to access

class APIFetchingDataHomePage: ObservableObject {

  func getUserRecentlyPlayed(accessToken: String,
                             completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/me/player/recently-played"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: MixedResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfItems = data.items.count

        var trackItems = [SpotifyModel.MediaItem]()

        guard numberOfItems != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        for trackIndex in 0 ..< numberOfItems {
          let title = data.items[trackIndex].track.name
          let previewURL = data.items[trackIndex].track.preview_url
          let imageURL = data.items[trackIndex].track.album.images?[0].url
          let author = data.items[trackIndex].track.artists[0].name
          let id = data.items[trackIndex].track.id

          let trackHref = data.items[trackIndex].track.href
          let popularity = data.items[trackIndex].track.popularity
          let explicit = data.items[trackIndex].track.explicit
          let durationInMs = data.items[trackIndex].track.duration_ms
          let albumName = data.items[trackIndex].track.album.name
          let albumHref = data.items[trackIndex].track.album.href
          let numberOfTracks = data.items[trackIndex].track.album.total_tracks

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL ?? "",
                                                 author: author,
                                                 type: "track",
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id,
                                                 details: SpotifyModel.DetailTypes.tracks(
                                                  trackDetails: SpotifyModel.TrackDetails(popularity: popularity,
                                                                                          explicit: explicit,
                                                                                          durationInMs: durationInMs,
                                                                                          href: trackHref,
                                                                                          album: SpotifyModel.AlbumDetails(name: albumName, numberOfTracks: numberOfTracks,
                                                                                                                           href: albumHref))))
          trackItems.append(trackItem)
        }
        completionHandler(trackItems)
      }

  }

  func getUserFavoriteTracks(accessToken: String,
                             limit: Int = 6,
                             offset: Int = 0,
                             completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/me/top/tracks?limit=\(limit)&offset=\(offset)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: GeneralResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfItems = data.items.count

        guard numberOfItems != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        var trackItems = [SpotifyModel.MediaItem]()

        for trackIndex in 0 ..< numberOfItems {
          let title = data.items[trackIndex].name
          let previewURL = data.items[trackIndex].preview_url
          let imageURL = data.items[trackIndex].album.images?[0].url
          let author = data.items[trackIndex].artists[0].name
          let id = data.items[trackIndex].id

          let trackHref = data.items[trackIndex].href
          let popularity = data.items[trackIndex].popularity
          let explicit = data.items[trackIndex].explicit
          let durationInMs = data.items[trackIndex].duration_ms
          let albumName = data.items[trackIndex].album.name
          let albumHref = data.items[trackIndex].album.href
          let numberOfTracks = data.items[trackIndex].album.total_tracks

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL ?? "",
                                                 author: author,
                                                 type: "track",
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id,
                                                 details: SpotifyModel.DetailTypes.tracks(
                                                  trackDetails: SpotifyModel.TrackDetails(popularity: popularity,
                                                                                          explicit: explicit,
                                                                                          durationInMs: durationInMs,
                                                                                          href: trackHref,
                                                                                          album: SpotifyModel.AlbumDetails(name: albumName, numberOfTracks: numberOfTracks,
                                                                                                                           href: albumHref))))
          trackItems.append(trackItem)
        }
        completionHandler(trackItems)
      }
  }

  func getUserFavoriteArtists(accessToken: String,
                             completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/me/top/artists"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: ArtistResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfArtists = data.items.count

        var artists = [SpotifyModel.MediaItem]()

        guard numberOfArtists != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        for itemIndex in 0 ..< numberOfArtists {
          let title = data.items[itemIndex].name
          let imageURL = data.items[itemIndex].images?[0].url
          let id = data.items[itemIndex].id

          let artistItem = SpotifyModel.MediaItem(title: title,
                                                  previewURL: "",
                                                  imageURL: imageURL ?? "",
                                                  author: "",
                                                  type: "artist",
                                                  isPodcast: false,
                                                  isArtist: true,
                                                  id: id,

                                                  // TODO: Put real data from api

                                                  details: SpotifyModel.DetailTypes.artists(artistDetails: SpotifyModel.ArtistDetails(followers: 0,
                                                                                                                                      genres: [""],
                                                                                                                                      popularity: 0,
                                                                                                                                      href: "")))
          artists.append(artistItem)
        }
        completionHandler(artists)
      }

  }

  func getArtist(accessToken: String,
                 artistID: String,
                 completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/artists/\(artistID)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: Artist.self) { response in

        guard let artist = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let name = artist.name
        let imageURL = artist.images?[0].url
        let id = artist.id

        let artistItem = SpotifyModel.MediaItem(title: "",
                                                previewURL: "",
                                                imageURL: imageURL ?? "",
                                                author: name,
                                                type: "artist",
                                                isPodcast: false,
                                                isArtist: true,
                                                id: id,

                                                // TODO: Put real data from api

                                                details: SpotifyModel.DetailTypes.artists(artistDetails: SpotifyModel.ArtistDetails(followers: 0,
                                                                                                                                    genres: [""],
                                                                                                                                    popularity: 0,
                                                                                                                                    href: "")))
        completionHandler([artistItem])
      }
  }

  func getNewReleases(accessToken: String,
                      limit: Int = 10,
                      offset: Int = 0,
                      completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let country = "US"

    let baseUrl = "https://api.spotify.com/v1/browse/new-releases?country=\(country)&limit=\(limit)&offset=\(offset)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: AlbumResponse.self) { response in

        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfItems = data.albums.items.count

        guard numberOfItems != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        var trackItems = [SpotifyModel.MediaItem]()

        for itemIndex in 0 ..< numberOfItems {
          let title = data.albums.items[itemIndex].name
          let imageURL = data.albums.items[itemIndex].images?[0].url
          let author = data.albums.items[itemIndex].artists[0].name // TODO: Support multiple artists
          let id = data.albums.items[itemIndex].id

          let albumHref = data.albums.items[itemIndex].href
          let numberOfTracks = data.albums.items[itemIndex].total_tracks

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: "",
                                                 imageURL: imageURL ?? "",
                                                 author: author,
                                                 type: "album",
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id,

                                                 // TODO: Put real data from api

                                                 details: SpotifyModel.DetailTypes.album(albumDetails: SpotifyModel.AlbumDetails(name: "",
                                                                                                                                 numberOfTracks: 0,
                                                                                                                                 href: "")))
          trackItems.append(trackItem)
        }
        completionHandler(trackItems)
      }

  }

  func getTopTracksFromArtist(accessToken: String,
                              country: String,
                              id: String,
                              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/artists/\(id)/top-tracks?market=\(country)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: TrackResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfTracks = data.tracks.count

        guard numberOfTracks != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        var trackItems = [SpotifyModel.MediaItem]()

        for trackIndex in 0 ..< numberOfTracks {
          let title = data.tracks[trackIndex].name
          let previewURL = data.tracks[trackIndex].preview_url
          let imageURL = data.tracks[trackIndex].album.images?[0].url
          let author = data.tracks[trackIndex].artists[0].name
          let id = data.tracks[trackIndex].id

          let trackHref = data.tracks[trackIndex].href
          let popularity = data.tracks[trackIndex].popularity
          let explicit = data.tracks[trackIndex].explicit
          let durationInMs = data.tracks[trackIndex].duration_ms
          let albumHref = data.tracks[trackIndex].album.href
          let numberOfTracks = data.tracks[trackIndex].album.total_tracks


          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL ?? "",
                                                 author: author,
                                                 type: "track",
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id,
                                                 details: SpotifyModel.DetailTypes.tracks(
                                                  trackDetails: SpotifyModel.TrackDetails(popularity: popularity,
                                                                                          explicit: explicit,
                                                                                          durationInMs: durationInMs,
                                                                                          href: trackHref,
                                                                                          album: SpotifyModel.AlbumDetails(name: "",
                                                                                                                           numberOfTracks: numberOfTracks,
                                                                                                                           href: albumHref))))
          trackItems.append(trackItem)
        }
        completionHandler(trackItems)
      }
  }

  func getTopPodcasts(accessToken: String,
                      limit: Int = 10,
                      offset: Int = 0,
                      completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let termSearch = "spotify+exclusive"
    let type = "show"
    let market = "US"

    let baseUrl = "https://api.spotify.com/v1/search?q=\(termSearch)&type=\(type)&market=\(market)&limit=\(limit)&offset=\(offset)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: ShowResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfItems = data.shows.items.count


        guard numberOfItems != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        var podcastItems = [SpotifyModel.MediaItem]()

        for itemIndex in 0 ..< numberOfItems {
          let title = data.shows.items[itemIndex].name
          let imageURL = data.shows.items[itemIndex].images[0].url
          let author = data.shows.items[itemIndex].publisher
          let id = data.shows.items[itemIndex].id

          let description = data.shows.items[itemIndex].description
          let showHref = data.shows.items[itemIndex].href
          let numberOfEpisodes = data.shows.items[itemIndex].total_episodes

          let podcastItem = SpotifyModel.MediaItem(title: title,
                                                   previewURL: "",
                                                   imageURL: imageURL,
                                                   author: author,
                                                   type: "podcast",
                                                   isPodcast: true,
                                                   isArtist: false,
                                                   id: id,

                                                   // TODO: Put real data from api

                                                   details: SpotifyModel.DetailTypes.shows(showDetails: SpotifyModel.ShowDetails(description: "",
                                                                                                                                 explicit: false,
                                                                                                                                 numberOfEpisodes: 0,
                                                                                                                                 href: "")))
          podcastItems.append(podcastItem)
        }
        completionHandler(podcastItems)
      }
  }

  func getFeaturedPlaylists(accessToken: String,
                    limit: Int = 20,
                    offset: Int = 0,
                    completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let country = "US"
    let baseUrl = "https://api.spotify.com/v1/browse/featured-playlists?country=\(country)&limit=\(limit)&offset=\(offset)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: FeaturedPlaylistsResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving playlists from API.")
        }

        let numberOfPlaylists = data.playlists.items.count

        var playlists = [SpotifyModel.MediaItem]()

        guard numberOfPlaylists != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        for itemIndex in 0 ..< numberOfPlaylists {
          let sectionTitle = data.message
          let title = data.playlists.items[itemIndex].name
          let imageURL = data.playlists.items[itemIndex].images[0].url
          let id = data.playlists.items[itemIndex].id

          let description = data.playlists.items[itemIndex].description
          let playlistTracks = data.playlists.items[itemIndex].tracks
          let mediaOwner = data.playlists.items[itemIndex].owner
          let href = data.playlists.items[itemIndex].href

          let playlistItem = SpotifyModel.MediaItem(title: title,
                                                    previewURL: sectionTitle,
                                                    imageURL: imageURL,
                                                    author: mediaOwner.display_name,
                                                    type: "playlist",
                                                    isPodcast: false,
                                                    isArtist: false,
                                                    id: id,
                                                    details: SpotifyModel.DetailTypes.playlists(
                                                      playlistDetails: SpotifyModel.PlaylistDetails(description: description,
                                                                                                    playlistTracks: SpotifyModel.PlaylistTracks(href: playlistTracks.href,
                                                                                                                                                numberOfSongs: playlistTracks.total),
                                                                                                    owner: SpotifyModel.MediaOwner(href: mediaOwner.href,
                                                                                                                                        displayName:mediaOwner.display_name),
                                                                                                    href: href)))

          playlists.append(playlistItem)
        }
        completionHandler(playlists)
      }
  }

  func getPlaylistsWith(keyWord: String,
                        accessToken: String,
                        limit: Int = 10,
                        offset: Int = 0,
                        completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let keyWord = keyWord.replacingOccurrences(of: " ", with: "+")
    let market = "US"
    let type = "playlist"

    let baseUrl = "https://api.spotify.com/v1/search?q=\(keyWord)&type=\(type)&market=\(market)&limit=\(limit)&offset=\(offset)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: PlaylistResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfPlaylists = data.playlists.items.count

        guard numberOfPlaylists != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        var playlists = [SpotifyModel.MediaItem]()

        for itemIndex in 0 ..< numberOfPlaylists {
          let title = data.playlists.items[itemIndex].name
          let imageURL = data.playlists.items[itemIndex].images[0].url
          let id = data.playlists.items[itemIndex].id

          let description = data.playlists.items[itemIndex].description
          let playlistTracks = data.playlists.items[itemIndex].tracks
          let mediaOwner = data.playlists.items[itemIndex].owner
          let href = data.playlists.items[itemIndex].href

          let playlistItem = SpotifyModel.MediaItem(title: title,
                                                    previewURL: "",
                                                    imageURL: imageURL,
                                                    author: mediaOwner.display_name,
                                                    type: "playlist",
                                                    isPodcast: false,
                                                    isArtist: false,
                                                    id: id,
                                                    details: SpotifyModel.DetailTypes.playlists(
                                                      playlistDetails: SpotifyModel.PlaylistDetails(description: description,
                                                                                                    playlistTracks: SpotifyModel.PlaylistTracks(href: playlistTracks.href,
                                                                                                                                                numberOfSongs: playlistTracks.total),
                                                                                                    owner: SpotifyModel.MediaOwner(href: mediaOwner.href,
                                                                                                                                        displayName:mediaOwner.display_name),
                                                                                                    href: href)))

          playlists.append(playlistItem)
        }
        completionHandler(playlists)
      }
  }

}
