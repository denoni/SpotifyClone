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
    }

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
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
          let imageURL = data.albums.items[itemIndex].images?[0].url
          let author = data.albums.items[itemIndex].artists
          let id = data.albums.items[itemIndex].id
          var authorName = [String]()

          let albumHref = data.albums.items[itemIndex].href
          let numberOfTracks = data.albums.items[itemIndex].total_tracks
          let releaseDate = data.albums.items[itemIndex].release_date

          for artistIndex in data.albums.items[itemIndex].artists.indices {
            authorName.append(data.albums.items[itemIndex].artists[artistIndex].name)
          }

          let trackItem = SpotifyModel.MediaItem(title: title,
                                                 previewURL: "",
                                                 imageURL: imageURL ?? "",
                                                 authorName: authorName,
                                                 author: author,
                                                 mediaType: .album,
                                                 id: id,
                                                 details: SpotifyModel.DetailTypes.album(albumDetails: SpotifyModel.AlbumDetails(name: title,
                                                                                                                                 numberOfTracks: numberOfTracks,
                                                                                                                                 href: albumHref,
                                                                                                                                 releaseDate: releaseDate)))
          trackItems.append(trackItem)
        }
        completionHandler(trackItems)
      }

  }


}
