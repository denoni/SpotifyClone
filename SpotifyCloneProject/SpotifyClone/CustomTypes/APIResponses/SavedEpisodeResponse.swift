//
//  SavedEpisodeResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/24/21.
//

import Foundation

struct SavedEpisodeResponse: Decodable {
  let items: [SavedEpisodeItem]

  struct SavedEpisodeItem: Decodable {
    let episode: Episode
  }
}
