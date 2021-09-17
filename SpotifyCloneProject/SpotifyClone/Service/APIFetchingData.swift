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

class APIFetchingData: ObservableObject {

  func getUserRecentlyPlayed(accessToken: String,
                             completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/me/player/recently-played"

    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(accessToken)"
    ]

    AF.request(baseUrl,
               method: .get,
               headers: headers)
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
          let imageURL = data.items[itemIndex].track.album.images[0].url
          let author = data.items[itemIndex].track.artists[0].name
          let type = data.items[itemIndex].track.type
          let id = data.items[itemIndex].track.id

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL,
                                                 author: author,
                                                 type: type,
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id)
          trackItems.append(trackItem)
          completionHandler(trackItems)
        }
      }
  }

  func getUserFavoriteTracks(accessToken: String,
                             completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/me/top/tracks"

    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(accessToken)"
    ]

    AF.request(baseUrl,
               method: .get,
               headers: headers)
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
          let imageURL = data.items[itemIndex].album.images[0].url
          let author = data.items[itemIndex].artists[0].name
          let type = data.items[itemIndex].type
          let id = data.items[itemIndex].id

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL,
                                                 author: author,
                                                 type: type,
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id)
          trackItems.append(trackItem)
          completionHandler(trackItems)
        }
      }
  }

  func getNewReleases(accessToken: String,
                             completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let country = "US"

    let baseUrl = "https://api.spotify.com/v1/browse/new-releases?country=\(country)"

    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(accessToken)"
    ]

    AF.request(baseUrl,
               method: .get,
               headers: headers)
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
          let imageURL = data.albums.items[itemIndex].images[0].url
          let author = data.albums.items[itemIndex].artists[0].name
          let type = data.albums.items[itemIndex].album_type
          let id = data.albums.items[itemIndex].id

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: "",
                                                 imageURL: imageURL,
                                                 author: author,
                                                 type: type,
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id)
          trackItems.append(trackItem)
          completionHandler(trackItems)
        }
      }
  }

  func getTopTracksFromArtist(accessToken: String,
                              country: String,
                              id: String,
                              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/artists/\(id)/top-tracks?market=\(country)"

    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(accessToken)"
    ]

    AF.request(baseUrl,
               method: .get,
               headers: headers)
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
          let imageURL = data.tracks[trackIndex].album.images[0].url
          let author = data.tracks[trackIndex].artists[0].name
          let type = data.tracks[trackIndex].type
          let id = data.tracks[trackIndex].id

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL,
                                                 author: author,
                                                 type: type,
                                                 isPodcast: false,
                                                 isArtist: false,
                                                 id: id)
          trackItems.append(trackItem)
          completionHandler(trackItems)
        }
      }
  }

  func getTopPodcasts(accessToken: String,
                             completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let termSearch = "podcast"
    let type = "show"
    let market = "US"

    let baseUrl = "https://api.spotify.com/v1/search?q=\(termSearch)&type=\(type)&market=\(market)"

    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(accessToken)"
    ]

    AF.request(baseUrl,
               method: .get,
               headers: headers)
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
          completionHandler(podcastItems)
        }
      }
  }
}
