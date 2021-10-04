//
//  PlayerControllerSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI
import AVKit

struct PlayerControllerSection: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @ObservedObject var audioManager = RemoteAudio()

  var urlString: String { mediaDetailVM.mainItem!.previewURL }

  var body: some View {
    VStack {
      audioManager.buildSliderForAudio()
      HStack {
        Image("play-mix")
          .resizeToFit()
          .padding(.vertical, 24)
          .onTapGesture {
            print(audioManager.state)
          }
        Spacer()

        Image("previous")
          .resizeToFit()
          .padding(.vertical, 22)
          .onTapGesture {
            audioManager.backwardFiveSeconds()
          }

        Spacer()

        ZStack {
          if audioManager.showPauseButton && !audioManager.isFirstTimePlaying {
            Image("circle-stop")
              .resizeToFit()
              .onTapGesture {
                audioManager.pause()
              }
          } else {
            Image("circle-play")
              .resizeToFit()
              .onTapGesture {

                let mediaURL = mediaDetailVM.mainItem!.previewURL
                if mediaURL.isEmpty {
                  print("\n\nEmpty preview URL. Spotify API doesn't provide preview for a lot of songs. A workaround will be found.\n\n")
                } else {

                  audioManager.play(urlString)
                }
              }
          }

          if audioManager.state == .buffering {
            ZStack {
              Circle()
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                .padding(1)
            }
            .scaledToFit()
          }

        }

        Spacer()

        Image("next")
          .resizeToFit()
          .padding(.vertical, 22)
          .onTapGesture {
            audioManager.forwardFiveSeconds()
          }

        Spacer()
        Image("play-repeat")
          .resizeToFit()
          .padding(.vertical, 24)
      }
      .frame(height: 70,
             alignment: .center)
    }
    .onDisappear {
      // When this View isn't being shown anymore stop the player
      audioManager.player.replaceCurrentItem(with: nil)
    }
  }
  
}
