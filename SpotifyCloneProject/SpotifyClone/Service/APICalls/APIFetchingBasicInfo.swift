//
//  APIFetchingBasicInfo.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/13/21.
//

import Foundation
import Alamofire

class APIFetchingBasicInfo {

  func getArtists(with accessToken: String,
                  artistIDs: [String],
                  completionHandler: @escaping ([SpotifyModel.MediaItem]) -> Void) {

    // %2c = comma
    let baseUrl = "https://api.spotify.com/v1/artists?ids=\(artistIDs.joined(separator: "%2c"))"

    let urlRequest = Utility.createStandardURLRequest(url: baseUrl, accessToken: accessToken)

    var artistItems = [SpotifyModel.MediaItem]()

    AF.request(urlRequest)
      .validate()
      .responseDecodable(of: ArtistResponse.self) { response in
        parseResponse(response)
      }

    func parseResponse(_ response: DataResponse<ArtistResponse, AFError>) {

      guard let data = response.value else {
        fatalError("Error receiving tracks from API.")
      }

      let numberOfArtists = response.value!.items.indices

      for artistIndex in numberOfArtists {
        let artist = data.items[artistIndex]

        let title = artist.name
        let imageURL = artist.images![0].url
        let id = artist.id

        let followers = artist.followers!.total
        let popularity = artist.popularity
        let genres = artist.genres

        let artistDetails = SpotifyModel.ArtistDetails(followers: followers, genres: genres!,
                                                       popularity: popularity!, id: id)

        let artistItem = SpotifyModel.MediaItem(title: title,
                                                  previewURL: "",
                                                  imageURL: imageURL ,
                                                  authorName: [title],
                                                  mediaType: .artist,
                                                  id: id,
                                                  details: SpotifyModel.DetailTypes.artists(artistDetails: artistDetails))
        artistItems.append(artistItem)
      }

      completionHandler(artistItems)
    }

  }

}
