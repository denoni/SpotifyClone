//
//  PlayerControllerSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct PlayerControllerSection: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State var mediaPlayer = RemoteAudio()
  @State var alreadyPlaying = false

  var body: some View {
    // TODO: Use real buttons, so it shows visual feedback when tapped
    HStack() {
      Image("play-mix")
        .resizeToFit()
        .padding(.vertical, 24)
      Spacer()
      Image("previous")
        .resizeToFit()
        .padding(.vertical, 22)
      Spacer()

      if alreadyPlaying {
        Image("circle-stop")
          .resizeToFit()
          .onTapGesture {
            alreadyPlaying = false
            mediaPlayer.pause()
          }
      } else {
        // TODO: Animate a loading indicator when already clicked but still loading.
        Image("circle-play")
          .resizeToFit()
          .onTapGesture {
            alreadyPlaying = true

            let mediaURL = mediaDetailVM.mainItem!.previewURL
            if mediaURL.isEmpty {
              print("\n\nEmpty preview URL. Spotify API doesn't provide preview for a lot of songs. A workaround will be found.\n\n")
            } else {
              mediaPlayer.play(mediaDetailVM.mainItem!.previewURL)
            }
          }
      }



      Spacer()
      Image("next")
        .resizeToFit()
        .padding(.vertical, 22)
      Spacer()
      Image("play-repeat")
        .resizeToFit()
        .padding(.vertical, 24)
    }
    .frame(height: 70,
           alignment: .center)
  }
}
