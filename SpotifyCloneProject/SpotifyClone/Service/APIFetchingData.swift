//
//  APIFetchingData.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation
import Alamofire

// TODO: Error handling for calls

class APIFetchingData: ObservableObject {
  @Published var topArtistDataHasLoaded = false

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
        print(numberOfTracks)

        var trackItems = [SpotifyModel.TrackItem]()

        for trackIndex in 0 ..< numberOfTracks {
          let name = data.tracks[trackIndex].name
          let previewURL = data.tracks[trackIndex].preview_url
          let imageURL = data.tracks[trackIndex].album.images[0].url
          let artist = data.tracks[trackIndex].artists[0].name
          let type = data.tracks[trackIndex].type
          let id = data.tracks[trackIndex].id

          print(imageURL)

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
    topArtistDataHasLoaded = true
  }
}
