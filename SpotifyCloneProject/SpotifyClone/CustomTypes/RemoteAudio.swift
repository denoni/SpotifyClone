//
//  RemoteAudio.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/4/21.
//

import SwiftUI
import AVKit

struct RemoteAudio {
  var player = AVPlayer()
  var isPaused = false
  var lastPlayedURL = ""
  @State var isLoading = false

  mutating func play(_ audioURL: String) {
    if !isPaused || lastPlayedURL != audioURL {
      let playerItem = AVPlayerItem(url: URL(string: audioURL)!)
      player = AVPlayer(playerItem: playerItem)
    }

    player.play()
    lastPlayedURL = audioURL
  }

  mutating func pause() {
    print(player.timeControlStatus == AVPlayer.TimeControlStatus.playing)
    player.pause()
    isPaused = true
  }

}
