//
//  APIFetchingDataSearchPage.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/20/21.
//

import Foundation
import Alamofire

class APIFetchingDataSearchPage: ObservableObject {

  // TODO: Add support for all media types
  func search(for searchTerm: String, accessToken: String,
              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    //      let country = "US"
    let type = "track"
    let baseUrl = "https://api.spotify.com/v1/search?q=\(searchTerm)&type=\(type)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    var trackItems = [SpotifyModel.MediaItem]()

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: SearchEndpointResponse.self) { response in
        parseResponse(response)
      }

    func parseResponse(_ response: DataResponse<SearchEndpointResponse, AFError>) {

      guard let data = response.value else {
        fatalError("Error receiving tracks from API.")
      }

      let numberOfItems = data.tracks.items.count

      // TODO: Handle empty responses in a better way
      guard numberOfItems != 0 else {
        completionHandler(trackItems)
        print("The API response was corrects but empty. We'll just return []")
        return
      }

      for trackIndex in 0 ..< numberOfItems {
        let title = data.tracks.items[trackIndex].name
        let previewURL = data.tracks.items[trackIndex].preview_url
        let author = data.tracks.items[trackIndex].artists
        let id = data.tracks.items[trackIndex].id
        var authorName = [String]()

        let popularity = data.tracks.items[trackIndex].popularity
        let explicit = data.tracks.items[trackIndex].explicit
        let durationInMs = data.tracks.items[trackIndex].duration_ms

        let imageURL = data.tracks.items[trackIndex].album?.images?[0].url
        let albumName = data.tracks.items[trackIndex].album?.name
        let albumID = data.tracks.items[trackIndex].album?.id
        let numberOfTracks = data.tracks.items[trackIndex].album?.total_tracks
        let releaseDate = data.tracks.items[trackIndex].album?.release_date

        for artistIndex in data.tracks.items[trackIndex].artists.indices {
          authorName.append(data.tracks.items[trackIndex].artists[artistIndex].name)
        }

        // Only for debugging, should be deleted
        print(title)

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
        trackItems.append(trackItem)
      }
      completionHandler(trackItems)
    }
  }

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
