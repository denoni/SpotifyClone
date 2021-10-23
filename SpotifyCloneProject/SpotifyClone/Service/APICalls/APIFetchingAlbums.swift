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

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    var albumItems = [SpotifyModel.MediaItem]()

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: AlbumResponse.self) { response in
        parseResponse(response)
      }

    func parseResponse(_ response: DataResponse<AlbumResponse, AFError>) {

      guard let data = response.value else {
        debugPrint(response.debugDescription)
        fatalError("\n Error receiving tracks from API.")
      }

      let numberOfItems = data.albums.count

      guard numberOfItems != 0 else {
        fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
      }



      for albumIndex in 0 ..< numberOfItems {
        let album = data.albums[albumIndex]

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

        let albumItem = SpotifyModel.MediaItem(title: title,
                                               previewURL: "",
                                               imageURL: imageURL ?? "",
                                               authorName: authorName,
                                               author: author,
                                               mediaType: .album,
                                               id: id,
                                               details: SpotifyModel.DetailTypes.album(albumDetails: SpotifyModel.AlbumDetails(name: title,
                                                                                                                               numberOfTracks: numberOfTracks,
                                                                                                                               releaseDate: releaseDate,
                                                                                                                               id: albumID)))

        albumItems.append(albumItem)
      }
      completionHandler(albumItems)
    }

  }
}
