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
                             completionHandler: @escaping ([SpotifyModel.TrackItem]) -> Void) {

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

        var trackItems = [SpotifyModel.TrackItem]()

        guard numberOfItems != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        for itemIndex in 0 ..< numberOfItems {
          let name = data.items[itemIndex].track.name
          let previewURL = data.items[itemIndex].track.preview_url
          let imageURL = data.items[itemIndex].track.album.images[0].url
          let artist = data.items[itemIndex].track.artists[0].name
          let type = data.items[itemIndex].track.type
          let id = data.items[itemIndex].track.id

          let trackItem = SpotifyModel.TrackItem(name: name,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL,
                                                 artist: artist,
                                                 type: type,
                                                 id: id)
          trackItems.append(trackItem)
          completionHandler(trackItems)
        }
      }
  }

  func getUserFavoriteTracks(accessToken: String,
                             completionHandler: @escaping ([SpotifyModel.TrackItem]) -> Void) {

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

        var trackItems = [SpotifyModel.TrackItem]()

        for itemIndex in 0 ..< numberOfItems {
          let name = data.items[itemIndex].name
          let previewURL = data.items[itemIndex].preview_url
          let imageURL = data.items[itemIndex].album.images[0].url
          let artist = data.items[itemIndex].artists[0].name
          let type = data.items[itemIndex].type
          let id = data.items[itemIndex].id

          let trackItem = SpotifyModel.TrackItem(name: name,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL,
                                                 artist: artist,
                                                 type: type,
                                                 id: id)
          trackItems.append(trackItem)
          completionHandler(trackItems)
        }
      }
  }

  func getNewReleases(accessToken: String,
                             completionHandler: @escaping ([SpotifyModel.TrackItem]) -> Void) {

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

        var trackItems = [SpotifyModel.TrackItem]()

        for itemIndex in 0 ..< numberOfItems {
          let name = data.albums.items[itemIndex].name
          let imageURL = data.albums.items[itemIndex].images[0].url
          let artist = data.albums.items[itemIndex].artists[0].name
          let type = data.albums.items[itemIndex].album_type
          let id = data.albums.items[itemIndex].id

          let trackItem = SpotifyModel.TrackItem(name: name,
                                                 previewURL: "",
                                                 imageURL: imageURL,
                                                 artist: artist,
                                                 type: type,
                                                 id: id)
          trackItems.append(trackItem)
          completionHandler(trackItems)
        }
      }
  }

  func getTopTracksFromArtist(accessToken: String,
                              country: String,
                              id: String,
                              completionHandler: @escaping ([SpotifyModel.TrackItem]) -> Void) {

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

        var trackItems = [SpotifyModel.TrackItem]()

        for trackIndex in 0 ..< numberOfTracks {
          let name = data.tracks[trackIndex].name
          let previewURL = data.tracks[trackIndex].preview_url
          let imageURL = data.tracks[trackIndex].album.images[0].url
          let artist = data.tracks[trackIndex].artists[0].name
          let type = data.tracks[trackIndex].type
          let id = data.tracks[trackIndex].id

          let trackItem = SpotifyModel.TrackItem(name: name,
                                                 previewURL: previewURL ?? "",
                                                 imageURL: imageURL,
                                                 artist: artist,
                                                 type: type,
                                                 id: id)
          trackItems.append(trackItem)
          completionHandler(trackItems)
        }
      }
  }
}
