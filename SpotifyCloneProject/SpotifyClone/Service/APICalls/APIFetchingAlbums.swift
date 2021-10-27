//
//  APIFetchingAlbums.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import Foundation
import Alamofire

class APIFetchingAlbums {

  enum AlbumsEndpointInAPI {
    case newReleases
    case artistAlbums(artistID: String)
  }

  func getAlbum(using endPoint: AlbumsEndpointInAPI,
                with accessToken: String,
                limit: Int = 10,
                offset: Int = 0,
                completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let country = "US"
    let baseUrl: String

    switch endPoint {
    case .newReleases:
      baseUrl = "https://api.spotify.com/v1/browse/new-releases?country=\(country)&limit=\(limit)&offset=\(offset)"
    case .artistAlbums(let artistID):
      baseUrl = "https://api.spotify.com/v1/artists/\(artistID)/albums"
    }

    let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: AlbumResponse.self) { response in

        let responseStatus = Utility.getResponseStatusCode(forValue: response.value, responseItemsCount: response.value?.albums.count)
        guard responseStatus != .empty else { return completionHandler([ SpotifyModel.MediaItem]() ) }

        completionHandler(self.parseResponse(response))
      }
  }

  private func parseResponse(_ response: DataResponse<AlbumResponse, AFError>) -> [SpotifyModel.MediaItem] {

    var albumItems = [SpotifyModel.MediaItem]()
    let numberOfItems = response.value!.albums.count

    for albumIndex in 0 ..< numberOfItems {
      let album = response.value!.albums[albumIndex]

      let title = album.name
      let imageURL = album.images?[0].url
      let author = album.artists
      let id = album.id
      var authorName = [String]()

      let albumID = album.id
      let numberOfTracks = album.total_tracks
      let releaseDate = album.release_date

      for artistIndex in album.artists.indices {
        authorName.append(album.artists[artistIndex].name)
      }

      let albumDetails = SpotifyModel.AlbumDetails(name: title, numberOfTracks: numberOfTracks,
                                                   releaseDate: releaseDate, id: albumID)

      let albumItem = SpotifyModel.MediaItem(title: title,
                                             previewURL: "",
                                             imageURL: imageURL ?? "",
                                             authorName: authorName,
                                             author: author,
                                             mediaType: .album,
                                             id: id,
                                             details: SpotifyModel.DetailTypes.album(albumDetails: albumDetails))

      albumItems.append(albumItem)
    }
    return albumItems
  }
}
