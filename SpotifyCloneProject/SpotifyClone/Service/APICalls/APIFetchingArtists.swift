//
//  APIFetchingArtists.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import Foundation
import Alamofire

class APIFetchingArtists {

  enum ArtistsEndpointInAPI {
    case userFavoriteArtists
    case userFollowedArtists
  }

  func getArtist(using endPoint: ArtistsEndpointInAPI,
                 with accessToken: String,
                 limit: Int = 10,
                 completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl: String

    switch endPoint {
    case .userFavoriteArtists:
      baseUrl = "https://api.spotify.com/v1/me/top/artists?limit=\(limit)"

    case .userFollowedArtists:
      baseUrl = "https://api.spotify.com/v1/me/following?type=artist"
    }

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    switch endPoint {
    case .userFavoriteArtists:
      AF.request(urlRequest)
        .validate()
        .responseDecodable(of: ArtistResponse.self) { response in
          guard let data = response.value else {
            fatalError("Error receiving tracks from API.")
          }

          let numberOfArtists = data.items.count
          var artists = [SpotifyModel.MediaItem]()

          guard numberOfArtists != 0 else {
            completionHandler(artists)
            print("The API response was corrects but empty. We'll just return []")
            return
          }

          for artistIndex in 0 ..< numberOfArtists {
            let artist = data.items[artistIndex]
            artists.append(self.parseArtistData(for: artist))
          }

          completionHandler(artists)
        }

    case .userFollowedArtists:
      AF.request(urlRequest)
        .validate()
        .responseDecodable(of: FollowedArtistResponse.self) { response in
          guard let data = response.value else {
            fatalError("Error receiving tracks from API.")
          }

          let numberOfArtists = data.artists.items.count
          var artists = [SpotifyModel.MediaItem]()

          guard numberOfArtists != 0 else {
            completionHandler(artists)
            print("The API response was corrects but empty. We'll just return []")
            return
          }

          for artistIndex in 0 ..< numberOfArtists {
            let artist = data.artists.items[artistIndex]
            artists.append(self.parseArtistData(for: artist))
          }

          completionHandler(artists)
        }
    }

  }

  // MARK: - Auxiliary functions

  func parseArtistData(for artist: Artist) -> SpotifyModel.MediaItem {

    let title = artist.name
    let imageURL = artist.images?[0].url
    let id = artist.id

    let followers = artist.followers!.total
    let genres = artist.genres
    let popularity = artist.popularity

    let artistDetails = SpotifyModel.ArtistDetails(followers: followers, genres: genres!,
                                                   popularity: popularity!, id: id)

    let artistItem = SpotifyModel.MediaItem(title: title,
                                            previewURL: "",
                                            imageURL: imageURL ?? "",
                                            authorName: [title],
                                            mediaType: .artist,
                                            id: id,
                                            details: SpotifyModel.DetailTypes.artists(artistDetails: artistDetails))
    return artistItem
  }
}
