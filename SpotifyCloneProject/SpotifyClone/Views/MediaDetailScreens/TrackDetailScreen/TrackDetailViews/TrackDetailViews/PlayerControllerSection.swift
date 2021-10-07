//
//  PlayerControllerSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI
import AVKit


import Alamofire

struct PlayerControllerSection: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @StateObject var audioManager = RemoteAudio()
  var isSmallDisplay: Bool = false

  var urlString: String { mediaDetailVM.mainItem!.previewURL }

  var body: some View {
    VStack {
      audioManager.buildSliderForAudio()
        .padding(.bottom, isSmallDisplay ? -5 : 0)

      HStack {
        Image("play-mix")
          .resizeToFit()
          .frame(width: isSmallDisplay ? 20 : 25)
        Spacer()
        Image("previous")
          .resizeToFit()
          .frame(width: isSmallDisplay ? 25 : 30)
          .onTapGesture {
            audioManager.backwardFiveSeconds()
          }
        Spacer()
        PlayStopButton(audioManager: audioManager,
                       isSmallDisplay: isSmallDisplay)
        Spacer()
        Image("next")
          .resizeToFit()
          .frame(width: isSmallDisplay ? 25 : 30)
          .onTapGesture {
            audioManager.forwardFiveSeconds()
          }
        Spacer()
        Image("play-repeat")
          .resizeToFit()
          .frame(width: isSmallDisplay ? 20 : 25)
      }
    }
    .padding(.bottom, isSmallDisplay ? -5 : 0)
    .onDisappear {
      // When this View isn't being shown anymore stop the player
      audioManager.player.replaceCurrentItem(with: nil)
    }
  }

  struct PlayStopButton: View {
    @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
    @StateObject var audioManager: RemoteAudio
    var isSmallDisplay: Bool = false

    var body: some View {
      ZStack {
        if audioManager.showPauseButton && !audioManager.lastPlayedURL.isEmpty  {
          Image("circle-stop")
            .resizeToFit()
            .onTapGesture {
              audioManager.pause()
            }
        } else {
          Image("circle-play")
            .resizeToFit()
            .onTapGesture {
              if mediaDetailVM.mainItem!.previewURL.isEmpty {
                audioManager.playWithItunes(forItem: mediaDetailVM.mainItem!, canPlayMoreThanOneAudio: false)
              } else {
                print(mediaDetailVM.mainItem!.previewURL)
                audioManager.play(mediaDetailVM.mainItem!.previewURL, audioID: mediaDetailVM.mainItem!.id)
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
      .frame(width: isSmallDisplay ? 60 : 70)
    }
  }
}
