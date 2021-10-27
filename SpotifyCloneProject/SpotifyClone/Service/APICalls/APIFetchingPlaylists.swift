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
    case currentUserPlaylists
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

    case .currentUserPlaylists:
      baseUrl = "https://api.spotify.com/v1/me/playlists"
    }

    let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: PlaylistResponse.self) { response in

        let responseStatus = Utility.getResponseStatusCode(forValue: response.value, responseItemsCount: response.value?.playlists.count)
        guard responseStatus != .empty else { return completionHandler( [SpotifyModel.MediaItem]() ) }

        completionHandler(self.parseResponse(response))
      }
  }

  private func parseResponse(_ response: DataResponse<PlaylistResponse, AFError>) -> [SpotifyModel.MediaItem] {

    var playlists = [SpotifyModel.MediaItem]()
    let numberOfPlaylists = response.value!.playlists.count

    for playlistIndex in 0 ..< numberOfPlaylists {
      let playlist = response.value!.playlists[playlistIndex]

      let sectionTitle = response.value!.message
      let title = playlist.name
      let imageURL = playlist.images[0].url
      let id = playlist.id

      let description = playlist.description
      let playlistTracks = playlist.tracks
      let mediaOwner = playlist.owner

      let infoAboutTracksInPlaylist = SpotifyModel.PlaylistTracks(numberOfSongs: playlistTracks.total, href: playlistTracks.href)
      let playlistOwner = SpotifyModel.MediaOwner(displayName: mediaOwner.display_name, id: mediaOwner.id)
      let playlistDetails = SpotifyModel.PlaylistDetails(description: description,
                                                         playlistTracks: infoAboutTracksInPlaylist,
                                                         owner: playlistOwner,
                                                         id: id)

      let playlistItem = SpotifyModel.MediaItem(title: title,
                                                previewURL: sectionTitle ?? "You Might Like",
                                                imageURL: imageURL,
                                                authorName: [mediaOwner.display_name],
                                                mediaType: .playlist,
                                                id: id,
                                                details: SpotifyModel.DetailTypes.playlists(playlistDetails: playlistDetails))
      playlists.append(playlistItem)
    }
    return playlists
  }

}
