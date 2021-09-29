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

  var trackAPI = APIFetchingTracks()
  var showsAPI = APIFetchingShows()

  // MARK: - TRACKS
  func getTrack(using endPoint: APIFetchingTracks.TrackEndpointInAPI,
                with accessToken: String,
                ifArtistsUseId artistID: String = "",
                limit: Int = 6,
                offset: Int = 0,
                completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    
    trackAPI.getTrack(using: endPoint, with: accessToken, ifArtistsUseId: artistID,
                      limit: limit, offset: offset, completionHandler: completionHandler)
  }

  // MARK: - SHOWS
  func getShow(using endPoint: APIFetchingShows.ShowsEndpointInAPI,
              with accessToken: String,
              limit: Int = 10,
              offset: Int = 0,
              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    showsAPI.getShow(using: endPoint, with: accessToken, limit: limit,
                     offset: offset, completionHandler: completionHandler)
  }





  // ARTIST

  func getUserFavoriteArtists(accessToken: String,
                              limit: Int = 10,
                              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/me/top/artists?limit=\(limit)"

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
                                                  authorName: [title],
                                                  mediaType: .artist,
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

  // ALBUM

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
          let author = data.albums.items[itemIndex].artists
          let id = data.albums.items[itemIndex].id
          var authorName = [String]()

          let albumHref = data.albums.items[itemIndex].href
          let numberOfTracks = data.albums.items[itemIndex].total_tracks
          let releaseDate = data.albums.items[itemIndex].release_date

          for artistIndex in data.albums.items[itemIndex].artists.indices {
            authorName.append(data.albums.items[itemIndex].artists[artistIndex].name)
          }

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: "",
                                                 imageURL: imageURL ?? "",
                                                 authorName: authorName,
                                                 author: author,
                                                 mediaType: .album,
                                                 id: id,
                                                 details: SpotifyModel.DetailTypes.album(albumDetails: SpotifyModel.AlbumDetails(name: title,
                                                                                                                                 numberOfTracks: numberOfTracks,
                                                                                                                                 href: albumHref,
                                                                                                                                 releaseDate: releaseDate)))
          trackItems.append(trackItem)
        }
        completionHandler(trackItems)
      }

  }


  // PLAYLIST

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
                                                    authorName: [mediaOwner.display_name],
                                                    mediaType: .playlist,
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
                                                    authorName: [mediaOwner.display_name],
                                                    mediaType: .playlist,
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

