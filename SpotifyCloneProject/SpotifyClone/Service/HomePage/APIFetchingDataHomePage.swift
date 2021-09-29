//
//  APIFetchingData.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation
import Alamofire

// TODO: Handle empty responses and errors
// TODO: The data received after decoding should be easier to access

class APIFetchingDataHomePage: ObservableObject {

  var trackAPI = APIFetchingTracks()
  var showsAPI = APIFetchingShows()
  var playlistAPI = APIFetchingPlaylists()
  var albumAPI = APIFetchingAlbums()

  // MARK: - TRACKS
  func getTrack(using endPoint: APIFetchingTracks.TrackEndpointInAPI,
                with accessToken: String,
                ifArtistsUseId artistID: String = "",
                limit: Int = 6,
                offset: Int = 0,
                completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    
    trackAPI.getTrack(using: endPoint, with: accessToken, ifArtistsUseId: artistID,
                      limit: limit, offset: offset, completionHandler: completionHandler)
  }

  // MARK: - SHOWS
  func getShow(using endPoint: APIFetchingShows.ShowsEndpointInAPI,
              with accessToken: String,
              limit: Int = 10,
              offset: Int = 0,
              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    showsAPI.getShow(using: endPoint, with: accessToken, limit: limit,
                     offset: offset, completionHandler: completionHandler)
  }

  // MARK: - PLAYLISTS

  func getPlaylist(using endPoint: APIFetchingPlaylists.PlaylistsEndpointInAPI,
                   with accessToken: String,
                   limit: Int = 10,
                   offset: Int = 0,
                   completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    playlistAPI.getPlaylist(using: endPoint, with: accessToken, limit: limit,
                            offset: offset, completionHandler: completionHandler)
  }

  // MARK: - PLAYLISTS

  func getAlbum(using endPoint: APIFetchingAlbums.AlbumsEndpointInAPI,
                with accessToken: String,
                limit: Int = 10,
                offset: Int = 0,
                completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {
    albumAPI.getAlbum(using: endPoint, with: accessToken, limit: limit,
                            offset: offset, completionHandler: completionHandler)
  }


  
  // ARTIST

  func getUserFavoriteArtists(accessToken: String,
                              limit: Int = 10,
                              completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    let baseUrl = "https://api.spotify.com/v1/me/top/artists?limit=\(limit)"

    var urlRequest = URLRequest(url: URL(string: baseUrl)!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: ArtistResponse.self) { response in
        guard let data = response.value else {
          fatalError("Error receiving tracks from API.")
        }

        let numberOfArtists = data.items.count

        var artists = [SpotifyModel.MediaItem]()

        guard numberOfArtists != 0 else {
          fatalError("The API response was corrects but empty. We don't have a way to handle this yet.")
        }

        for itemIndex in 0 ..< numberOfArtists {
          let title = data.items[itemIndex].name
          let imageURL = data.items[itemIndex].images?[0].url
          let id = data.items[itemIndex].id

          let artistItem = SpotifyModel.MediaItem(title: title,
                                                  previewURL: "",
                                                  imageURL: imageURL ?? "",
                                                  authorName: [title],
                                                  mediaType: .artist,
                                                  id: id,

                                                  // TODO: Put real data from api

                                                  details: SpotifyModel.DetailTypes.artists(artistDetails: SpotifyModel.ArtistDetails(followers: 0,
                                                                                                                                      genres: [""],
                                                                                                                                      popularity: 0,
                                                                                                                                      href: "")))
          artists.append(artistItem)
        }
        completionHandler(artists)
      }
  }
  
}

