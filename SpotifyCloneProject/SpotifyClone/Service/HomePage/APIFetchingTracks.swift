//
//  APIFetchingTracks.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/27/21.
//

import Foundation
import Alamofire

class APIFetchingTracks {

  enum TrackEndpointInAPI {
    case userRecentlyPlayed
    case userFavoriteTracks
    case topTracksFromArtist
  }

  func getTrack(using endPoint: TrackEndpointInAPI,
                with accessToken: String,
                ifArtistsUseId artistID: String = "",
                limit: Int = 6,
                offset: Int = 0,
                completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl: String

    switch endPoint {
    case .userRecentlyPlayed:
      baseUrl = "https://api.spotify.com/v1/me/player/recently-played?limit=20"
    case .userFavoriteTracks:
      baseUrl = "https://api.spotify.com/v1/me/top/tracks?limit=\(limit)&offset=\(offset)"
    case .topTracksFromArtist:
      baseUrl = "https://api.spotify.com/v1/artists/\(artistID)/top-tracks?market=US"
    }

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    var trackItems = [SpotifyModel.MediaItem]()

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: TrackResponse.self) { response in
        parseResponse(response)
      }


    func parseResponse(_ response: DataResponse<TrackResponse, AFError>) {

      guard let data = response.value else {
        fatalError("Error receiving tracks from API.")
      }

      let numberOfItems = data.tracks.count

      guard numberOfItems != 0 else {
        fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
      }

      for trackIndex in 0 ..< numberOfItems {
        let title = data.tracks[trackIndex].name
        let previewURL = data.tracks[trackIndex].preview_url
        let imageURL = data.tracks[trackIndex].album.images?[0].url
        let author = data.tracks[trackIndex].artists
        let id = data.tracks[trackIndex].id
        var authorName = [String]()

        let trackHref = data.tracks[trackIndex].href
        let popularity = data.tracks[trackIndex].popularity
        let explicit = data.tracks[trackIndex].explicit
        let durationInMs = data.tracks[trackIndex].duration_ms
        let albumName = data.tracks[trackIndex].album.name
        let albumHref = data.tracks[trackIndex].album.href
        let numberOfTracks = data.tracks[trackIndex].album.total_tracks
        let releaseDate = data.tracks[trackIndex].album.release_date

        for artistIndex in data.tracks[trackIndex].artists.indices {
          authorName.append(data.tracks[trackIndex].artists[artistIndex].name)
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
                      trackDetails: SpotifyModel.TrackDetails(popularity: popularity,
                                                              explicit: explicit,
                                                              durationInMs: durationInMs,
                                                              href: trackHref,
                                                              album: SpotifyModel.AlbumDetails(name: albumName,
                                                                                               numberOfTracks: numberOfTracks,
                                                                                               href: albumHref,
                                                                                               releaseDate: releaseDate))))
        trackItems.append(trackItem)
      }
      completionHandler(trackItems)
    }
  }
}
