//
//  SearchEndpointResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import Foundation

/// # Used in any response from the Search endpoint of the API

// TODO: use custom init with `if` to support all media types.
struct SearchEndpointResponse: Decodable {
  let tracks: TrackSearchResponse

  struct TrackSearchResponse: Decodable {
    var items: [Track]
  }
}
