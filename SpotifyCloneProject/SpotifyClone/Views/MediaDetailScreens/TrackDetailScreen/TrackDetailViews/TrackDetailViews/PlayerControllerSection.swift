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

  private var urlString: String { mediaDetailVM.mainItem!.previewURL }

  var body: some View {
    VStack {
      audioManager.buildSliderForAudio()
        .padding(.bottom, isSmallDisplay ? -5 : 0)

      HStack {
        Rectangle()
          .fill(Color.clear)
          .overlay(Text(audioManager.currentRate)
                    .font(.avenir(.medium, size: isSmallDisplay ? 15 : 18))
                    .fixedSize())
          .frame(width: isSmallDisplay ? 20 : 25)
          .onTapGesture {
            audioManager.changePlayingRate(audioManager: audioManager)
          }
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
          .fixedSize()
        Spacer()
        Image("next")
          .resizeToFit()
          .frame(width: isSmallDisplay ? 25 : 30)
          .onTapGesture {
            audioManager.forwardFiveSeconds()
          }
        Spacer()
        HeartButton(mediaDetailVM: mediaDetailVM,
                    itemID: mediaDetailVM.mainItem!.id,
                    itemType: .track)
          .frame(width: isSmallDisplay ? 20 : 25)
      }
    }
    .padding(.bottom, isSmallDisplay ? -5 : 0)
    .onDisappear {
      // When this View isn't being shown anymore stop the player
      audioManager.player.replaceCurrentItem(with: nil)
    }
  }

  private struct PlayStopButton: View {
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
