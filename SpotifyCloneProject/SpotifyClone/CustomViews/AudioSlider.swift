//
//  AudioSlider.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/4/21.
//

import SwiftUI

struct AudioSlider: View {
  @ObservedObject var remoteAudio: RemoteAudio

  var body: some View {
    VStack {
      Slider(value: $remoteAudio.currentTime,
             in: 0...remoteAudio.currentDuration,
             onEditingChanged: remoteAudio.sliderEditingChanged) {
        Text("Audio Player Slider")
      }
      .accentColor(.spotifyGreen)
      .disabled(remoteAudio.state != .active)
      HStack {
        Text(Utility.formatTimeToHourMinSec(for: .seconds(remoteAudio.currentTime)))
          .font(.avenir(.medium, size: Constants.fontXSmall))
          .opacity(Constants.opacityStandard)
        Spacer()
        Text(Utility.formatTimeToHourMinSec(for: .seconds(remoteAudio.currentDuration)))
          .font(.avenir(.medium, size: Constants.fontXSmall))
          .opacity(Constants.opacityStandard)
      }
    }
    // Listen out for the time observer publishing changes to the player's time
    .onReceive(remoteAudio.timeObserver.publisher) { time in
      // Update the local var
      remoteAudio.currentTime = time
      // And flag that we've started playback
      if time > 0 {
        remoteAudio.state = .active
      }

      // If reach the end, move to start position(time).
      if remoteAudio.currentTime.rounded() == remoteAudio.currentDuration.rounded() {
        remoteAudio.moveToStartTime()
      }
    }
    // Listen out for the duration observer publishing changes to the player's item duration
    .onReceive(remoteAudio.durationObserver.publisher) { duration in
      // Update the local var
      remoteAudio.currentDuration = duration
    }
    // Listen out for the item observer publishing a change to whether the player has an item
    .onReceive(remoteAudio.itemObserver.publisher) { hasItem in
      remoteAudio.state = hasItem ? .buffering : .waitingForSelection
      remoteAudio.currentTime = 0
      remoteAudio.currentDuration = 0
    }
  }
}
