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
    case userLikedTracks
    case topTracksFromArtist(artistID: String)
    case tracksFromPlaylist(playlistID: String)
    case tracksFromAlbum(albumID: String)
  }

  func getTrack(using endPoint: TrackEndpointInAPI,
                with accessToken: String,
                limit: Int = 6,
                offset: Int = 0,
                completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl: String

    switch endPoint {
    case .userRecentlyPlayed:
      baseUrl = "https://api.spotify.com/v1/me/player/recently-played?limit=20"
    case .userFavoriteTracks:
      baseUrl = "https://api.spotify.com/v1/me/top/tracks?limit=\(limit)&offset=\(offset)"
    case .userLikedTracks:
      baseUrl = "https://api.spotify.com/v1/me/tracks"
    case .topTracksFromArtist(let artistID):
      baseUrl = "https://api.spotify.com/v1/artists/\(artistID)/top-tracks?market=US"
    case .tracksFromPlaylist(let playlistID):
      baseUrl = "https://api.spotify.com/v1/playlists/\(playlistID)/tracks?limit=\(limit)&offset=\(offset)"
    case .tracksFromAlbum(let albumID):
      baseUrl = "https://api.spotify.com/v1/albums/\(albumID)/tracks?limit=\(limit)&offset=\(offset)"
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
        completionHandler(trackItems)
        print("The API response was corrects but empty. We'll just return []")
        return
      }

      for trackIndex in 0 ..< numberOfItems {
        let track = data.tracks[trackIndex]

        let title = track.name
        let previewURL = track.preview_url
        let author = track.artists
        let id = track.id
        var authorName = [String]()

        let popularity = track.popularity
        let explicit = track.explicit
        let durationInMs = track.duration_ms

        let imageURL = track.album?.images?[0].url
        let lowResImageURL = track.album?.images?.last?.url
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
                     lowResImageURL: imageURL ?? "",
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
}
