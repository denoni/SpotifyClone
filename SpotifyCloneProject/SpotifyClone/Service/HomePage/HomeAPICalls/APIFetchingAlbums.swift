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
        fatalError("Error receiving tracks from API.")
      }

      let numberOfItems = data.albums.count

      guard numberOfItems != 0 else {
        fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
      }



      for albumIndex in 0 ..< numberOfItems {
        let title = data.albums[albumIndex].name
        let imageURL = data.albums[albumIndex].images?[0].url
        let author = data.albums[albumIndex].artists
        let id = data.albums[albumIndex].id
        var authorName = [String]()

        let albumID = data.albums[albumIndex].id
        let numberOfTracks = data.albums[albumIndex].total_tracks
        let releaseDate = data.albums[albumIndex].release_date

        for artistIndex in data.albums[albumIndex].artists.indices {
          authorName.append(data.albums[albumIndex].artists[artistIndex].name)
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
