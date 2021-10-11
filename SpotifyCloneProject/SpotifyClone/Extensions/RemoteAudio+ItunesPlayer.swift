//
//  RemoteAudio+ItunesPlayer.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/4/21.
//

import Foundation
import Alamofire

extension RemoteAudio {
  func playWithItunes(forItem item: SpotifyModel.MediaItem, canPlayMoreThanOneAudio: Bool) {

    if !canPlayMoreThanOneAudio {
      // In this case, if the player was already used, that means
      // that we don't need to grab a new URL from the API, we
      // may just grab the URL from `lastPlayedURL` instead.
      guard self.lastPlayedURL.isEmpty else {
        self.play(self.lastPlayedURL, audioID: item.id)
        return
      }
    }

    var songName: String {
      var strippedName = item.title
      if item.title.contains("(") {
        let firstOccurrenceIndex = strippedName.firstIndex(of: "(")!
        let lastIndex = strippedName.endIndex
        strippedName.removeSubrange(firstOccurrenceIndex ..< lastIndex)
      }
      // Use strippedName here(instead of item.title), otherwise if the first
      // check(contains "(") return true and the second one too, it'll cause a crash.
      if strippedName.contains("-") {
        let firstOccurrenceIndex = strippedName.firstIndex(of: "-")!
        let lastIndex = strippedName.endIndex
        strippedName.removeSubrange(firstOccurrenceIndex ..< lastIndex)
      }
      return strippedName
        .removeSpecialChars
        .replacingOccurrences(of: " ", with: "+")
        .lowercased()
    }

    let baseUrl = "https://itunes.apple.com/search?term=\(songName)&limit=1&entity=song"

    AF.request(URLRequest(url: URL(string: baseUrl)!))
      .validate()
      .responseDecodable(of: ItunesTrackResponse.self) { response in
        guard response.value != nil else {
          var errorMessage = "No specific error message."
          if response.error != nil { errorMessage = response.error!.localizedDescription }
          print(">>> Error in iTunes response. \(errorMessage)")
          return
        }

        if canPlayMoreThanOneAudio {
          self.pause()
        }

        self.play(response.value!.results[0].previewUrl, audioID: item.id)


        print("""

              >>> iTunes URL:
              \(response.value!.results[0].previewUrl)
              >>> THIS SOLUTION IS A WORKAROUND AND MAY CAUSE SOME UNEXPECTED BEHAVIOUR.

              """)
      }

  }

  private struct ItunesTrackResponse: Decodable {
    var results: [TrackResult]

    struct TrackResult: Decodable {
      var previewUrl: String
    }
  }
}
