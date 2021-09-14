//
//  APIFetchingData.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation
import Alamofire

// TODO: Error handling for calls

struct APIFetchingData {

  static func getTopTracksFromArtist(accessToken: String,
                              country: String,
                              id: String,
                              completionHandler: @escaping (TrackItem) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/artists/\(id)/top-tracks?market=\(country)"

    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(accessToken)"
    ]

    AF.request(baseUrl,
               method: .get,
               headers: headers)
      .responseDecodable(of: Tracks.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving access keys from API.")
        }

        let firstTrack = data.tracks[0]


        let name = firstTrack.name
        let previewURL = firstTrack.preview_url
        let imageURL = firstTrack.album.images[0].url
        let artist = firstTrack.artists[0].name
        let type = firstTrack.type
        let id = firstTrack.id

        let trackItem = TrackItem(name: name,
                                  previewURL: previewURL,
                                  imageURL: imageURL,
                                  artist: artist,
                                  type: type,
                                  id: id)

        completionHandler(trackItem)
      }
  }
}
