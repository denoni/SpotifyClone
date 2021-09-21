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

        for itemIndex in 0 ..< numberOfItems {
          let title = data.items[itemIndex].track.name
          let previewURL = data.items[itemIndex].track.preview_url
          let imageURL = data.items[itemIndex].track.album.images?[0].url
          let author = data.items[itemIndex].track.artists[0].name
          let type = data.items[itemIndex].track.type
          let id = data.items[itemIndex].track.id

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL ?? "",
                                                 author: author,
                                                 type: type,
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id)
          trackItems.append(trackItem)
        }
        completionHandler(trackItems)
      }

  }

  func getUserFavoriteTracks(accessToken: String,
                             completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/me/top/tracks"

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

        for itemIndex in 0 ..< numberOfItems {
          let title = data.items[itemIndex].name
          let previewURL = data.items[itemIndex].preview_url
          let imageURL = data.items[itemIndex].album.images?[0].url
          let author = data.items[itemIndex].artists[0].name
          let type = data.items[itemIndex].type
          let id = data.items[itemIndex].id

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL ?? "",
                                                 author: author,
                                                 type: type,
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id)
          trackItems.append(trackItem)
        }
        completionHandler(trackItems)
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
                                                type: "",
                                                isPodcast: false,
                                                isArtist: true,
                                                id: id)
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
          let author = data.albums.items[itemIndex].artists[0].name
          let type = data.albums.items[itemIndex].album_type
          let id = data.albums.items[itemIndex].id

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: "",
                                                 imageURL: imageURL ?? "",
                                                 author: author,
                                                 type: type,
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id)
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
      .responseDecodable(of: TracksResponse.self) { response in
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
          let type = data.tracks[trackIndex].type
          let id = data.tracks[trackIndex].id

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL ?? "",
                                                 author: author,
                                                 type: type,
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id)
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
      .responseDecodable(of: PodcastsResponse.self) { response in
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
          let type = data.shows.items[itemIndex].type
          let id = data.shows.items[itemIndex].id

          let podcastItem = SpotifyModel.MediaItem(title: title,
                                                   previewURL: "",
                                                   imageURL: imageURL,
                                                   author: author,
                                                   type: type,
                                                   isPodcast: true,
                                                   isArtist: false,
                                                   id: id)
          podcastItems.append(podcastItem)
        }
        completionHandler(podcastItems)
      }
  }

  func getPlaylists(accessToken: String,
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

        for index in 0 ..< numberOfPlaylists {
          let sectionTitle = data.message
          let title = data.playlists.items[index].name
          let imageURL = data.playlists.items[index].images[0].url
          let id = data.playlists.items[index].id

          let playlistItem = SpotifyModel.MediaItem(title: title,
                                                    previewURL: "",
                                                    imageURL: imageURL,
                                                    author: sectionTitle,
                                                    type: "",
                                                    isPodcast: false,
                                                    isArtist: false,
                                                    id: id)
          playlists.append(playlistItem)
        }
        completionHandler(playlists)
      }
  }


}
