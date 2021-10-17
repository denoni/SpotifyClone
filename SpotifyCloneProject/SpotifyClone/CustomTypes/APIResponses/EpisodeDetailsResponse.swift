//
//  EpisodeDetailsResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/14/21.
//

import Foundation

struct EpisodeDetailsResponse: Decodable {
  let audio_preview_url: String
  let description: String
  let duration_ms: Double
  let explicit: Bool
  let id: String
  let images: [CoverImage]
  let name: String
  let show: Show
  let release_date: String
}
