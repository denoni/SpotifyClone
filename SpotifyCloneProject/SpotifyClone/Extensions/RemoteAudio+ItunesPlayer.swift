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

    var songAndArtistName: String {
      // Remove everything after the first space(case it has) (e.g. Bob Marley -> Bob)
      let strippedArtistName = checkAndRemoveEverythingAfter(unwantedCharacter: " ", in: item.authorName.first ?? "")

      var strippedArtistAndSongTitle = "\(item.title) \(strippedArtistName)"
      strippedArtistAndSongTitle = checkAndRemoveEverythingAfter(unwantedCharacter: "(", in: strippedArtistAndSongTitle)
      strippedArtistAndSongTitle = checkAndRemoveEverythingAfter(unwantedCharacter: "-", in: strippedArtistAndSongTitle)

      return strippedArtistAndSongTitle
        .removeSpecialChars
        .replacingOccurrences(of: " ", with: "+")
        .lowercased()
    }

    let baseUrl = "https://itunes.apple.com/search?term=\(songAndArtistName)&limit=1&entity=song"

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
  }
  private struct TrackResult: Decodable {
    var previewUrl: String
  }
}

private func checkAndRemoveEverythingAfter(unwantedCharacter: Character, in inputString: String) -> String {
  var strippedString = inputString
  if strippedString.contains(unwantedCharacter) {
    let firstOccurrenceIndex = inputString.firstIndex(of: unwantedCharacter)!
    let lastIndex = inputString.endIndex
    strippedString.removeSubrange(firstOccurrenceIndex ..< lastIndex)
  }
  return strippedString
}
