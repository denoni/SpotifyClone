//
//  APIFetchingPlaylists.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import Foundation
import Alamofire

class APIFetchingPlaylists {

  enum PlaylistsEndpointInAPI {
    case featuredPlaylists
    case playlistWithKeyword(keyWord: String)
  }

  func getPlaylist(using endPoint: PlaylistsEndpointInAPI,
                   with accessToken: String,
                   limit: Int = 10,
                   offset: Int = 0,
                   completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let country = "US"
    let baseUrl: String

    switch endPoint {
    case .featuredPlaylists:
      baseUrl = "https://api.spotify.com/v1/browse/featured-playlists?country=\(country)&limit=\(limit)&offset=\(offset)"
    case .playlistWithKeyword(let keyWord):
      let keyWord = keyWord.replacingOccurrences(of: " ", with: "+")
      let type = "playlist"
      baseUrl = "https://api.spotify.com/v1/search?q=\(keyWord)&type=\(type)&market=\(country)&limit=\(limit)&offset=\(offset)"
    }

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    var trackItems = [SpotifyModel.MediaItem]()

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: PlaylistResponse.self) { response in
        parseResponse(response)
      }

    func parseResponse(_ response: DataResponse<PlaylistResponse, AFError>) {

      guard let data = response.value else {
        fatalError("Error receiving tracks from API.")
      }

      let numberOfPlaylists = data.playlists.items.count

      guard numberOfPlaylists != 0 else {
        fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
      }

      for playlistIndex in 0 ..< numberOfPlaylists {
        let sectionTitle = data.message
        let title = data.playlists.items[playlistIndex].name
        let imageURL = data.playlists.items[playlistIndex].images[0].url
        let id = data.playlists.items[playlistIndex].id

        let description = data.playlists.items[playlistIndex].description
        let playlistTracks = data.playlists.items[playlistIndex].tracks
        let mediaOwner = data.playlists.items[playlistIndex].owner
        let href = data.playlists.items[playlistIndex].href

        let playlistItem = SpotifyModel.MediaItem(title: title,
                                                  previewURL: sectionTitle ?? "You Might Like",
                                                  imageURL: imageURL,
                                                  authorName: [mediaOwner.display_name],
                                                  mediaType: .playlist,
                                                  id: id,
                                                  details: SpotifyModel.DetailTypes.playlists(
                                                    playlistDetails: SpotifyModel.PlaylistDetails(description: description,
                                                                                                  playlistTracks: SpotifyModel.PlaylistTracks(href: playlistTracks.href,
                                                                                                                                              numberOfSongs: playlistTracks.total),
                                                                                                  owner: SpotifyModel.MediaOwner(href: mediaOwner.href,
                                                                                                                                 displayName:mediaOwner.display_name),
                                                                                                  href: href)))
        trackItems.append(playlistItem)
      }
      completionHandler(trackItems)
    }

  }

}
