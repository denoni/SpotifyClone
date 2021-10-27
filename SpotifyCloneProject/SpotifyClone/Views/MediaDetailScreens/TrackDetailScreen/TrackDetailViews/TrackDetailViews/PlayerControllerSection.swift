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
        PlayingRateButton(audioManager: audioManager, isSmallDisplay: isSmallDisplay)
        Spacer()
        BackwardButton(audioManager: audioManager, isSmallDisplay: isSmallDisplay)
        Spacer()
        PlayStopButton(audioManager: audioManager, isSmallDisplay: isSmallDisplay)
          .fixedSize()
        Spacer()
        ForwardButton(audioManager: audioManager, isSmallDisplay: isSmallDisplay)
        Spacer()
        HeartButton(mediaDetailVM: mediaDetailVM, itemID: mediaDetailVM.mainItem!.id, itemType: .track)
          .frame(width: isSmallDisplay ? 20 : 25)
      }
    }
    .padding(.bottom, isSmallDisplay ? -5 : 0)
    .onDisappear {
      // When this View isn't being shown anymore stop the player
      audioManager.player.replaceCurrentItem(with: nil)
    }
  }

  private struct PlayingRateButton: View {
    @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
    @StateObject var audioManager: RemoteAudio
    var isSmallDisplay: Bool = false

    var body: some View {
      Button(action: { audioManager.changePlayingRate(audioManager: audioManager) },
             label: {
        Rectangle()
          .fill(Color.clear)
          .overlay(Text(audioManager.currentRateString)
                    .font(.avenir(.medium, size: isSmallDisplay ? 15 : 18))
                    .fixedSize())
          .frame(width: isSmallDisplay ? 20 : 25)
      })
      .buttonStyle(PlainButtonStyle())
      .disabled(audioManager.state != .active)
    }
  }

  private struct ForwardButton: View {
    @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
    @StateObject var audioManager: RemoteAudio
    var isSmallDisplay: Bool = false

    var body: some View {
      Button(action: { audioManager.forwardFiveSeconds() },
             label: {
        Image("next")
          .resizeToFit()
          .frame(width: isSmallDisplay ? 25 : 30)
      })
      .buttonStyle(PlainButtonStyle())
      .disabled(audioManager.state != .active)
    }
  }

  private struct BackwardButton: View {
    @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
    @StateObject var audioManager: RemoteAudio
    var isSmallDisplay: Bool = false

    var body: some View {
      Button(action: { audioManager.backwardFiveSeconds() },
             label: {
        Image("previous")
          .resizeToFit()
          .frame(width: isSmallDisplay ? 25 : 30)
      })
      .buttonStyle(PlainButtonStyle())
      .disabled(audioManager.state != .active)
    }
  }

  private struct PlayStopButton: View {
    @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
    @StateObject var audioManager: RemoteAudio
    var isSmallDisplay: Bool = false

    var body: some View {
      Button {
        if audioManager.showPauseButton && !audioManager.lastPlayedURL.isEmpty {
          audioManager.pause()
        } else {
          if mediaDetailVM.mainItem!.previewURL.isEmpty {
            audioManager.playWithItunes(forItem: mediaDetailVM.mainItem!, canPlayMoreThanOneAudio: false)
          } else {
            audioManager.play(mediaDetailVM.mainItem!.previewURL, audioID: mediaDetailVM.mainItem!.id)
          }
        }
      } label: {
        ZStack {
          if audioManager.showPauseButton && !audioManager.lastPlayedURL.isEmpty {
            Image("circle-stop")
              .resizeToFit()
          } else {
            Image("circle-play")
              .resizeToFit()
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
      .buttonStyle(PlainButtonStyle())
    }
  }
}
