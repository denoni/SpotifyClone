//
//  RemoteAudio.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/4/21.
//

// The code is an adaptation of github.com/ChrisMash/AVPlayer-SwiftUI

import SwiftUI
import AVKit
import Combine

class RemoteAudio: ObservableObject {

  var player: AVPlayer
  let timeObserver: PlayerTimeObserver
  let durationObserver: PlayerDurationObserver
  let itemObserver: PlayerItemObserver
  @Published var currentTime: TimeInterval = 0
  @Published var currentDuration: TimeInterval = 0
  @Published private(set) var currentRateString: String = "1x"
  // We need this because the player resets it's own rate tracker when user pauses, skips 5sec, etc...
  @Published private var currentRate: Float = 1.0
  @Published var state = PlaybackState.waitingForSelection

  @Published private(set) var lastPlayedURL = ""
  @Published private(set) var lastItemPlayedID = ""
  @Published private(set) var showPauseButton = false

  // Used to check buffering. This is a workaround for cases where the `RemoteAudio.state` doesn't work
  @Published var isBuffering = false
  private(set) var bufferingCheckerTimer: Publishers.Autoconnect<Timer.TimerPublisher>?

  init() {
    player = AVPlayer()
    timeObserver = PlayerTimeObserver(player: player)
    durationObserver = PlayerDurationObserver(player: player)
    itemObserver = PlayerItemObserver(player: player)
    isBuffering = (player.timeControlStatus == .waitingToPlayAtSpecifiedRate)

    startObservingForBufferingState()
  }

  func play(_ audioURL: String, audioID: String) {
    if !showPauseButton && lastPlayedURL != audioURL {
      let playerItem = AVPlayerItem(url: URL(string: audioURL)!)
      player.replaceCurrentItem(with: playerItem)
    }

    player.playImmediately(atRate: currentRate)
    lastPlayedURL = audioURL
    lastItemPlayedID = audioID
    showPauseButton = true
  }

  func pause() {
    player.pause()
    showPauseButton = false
  }

  func changePlayingRate(audioManager: RemoteAudio) {
    if currentRate == 0.5 {
      player.rate = 1.0
      currentRate = 1.0
      currentRateString = "1x"
    } else if currentRate == 1.0 {
      player.rate = 1.5
      currentRate = 1.5
      currentRateString = "1.5x"
    } else if currentRate == 1.5 {
      player.rate = 2.0
      currentRate = 2.0
      currentRateString = "2x"
    } else if currentRate == 2.0 {
      player.rate = 0.5
      currentRate = 0.5
      currentRateString = "0.5x"
    }

    refreshPlayerCasePaused()
  }

  func forwardFiveSeconds() {
    changeCurrentTime(by: 5)
  }

  func backwardFiveSeconds() {
    changeCurrentTime(by: -5)
  }

  func moveToStartTime() {
    let minimumTime = CMTime(seconds: 0, preferredTimescale: 600)

    player.seek(to: minimumTime) { [weak self] _ in
      self?.timeObserver.pause(false)
      self?.state = .active
    }

    refreshPlayerCasePaused()
  }

  func checkIfIsBuffering() {
    isBuffering = (player.timeControlStatus == .waitingToPlayAtSpecifiedRate)
  }

  func startObservingForBufferingState() {
    bufferingCheckerTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  }

  func stopObservingForBufferingState() {
    bufferingCheckerTimer!.upstream.connect().cancel()
  }

  private func changeCurrentTime(by time: Double) {

    timeObserver.pause(true)
    var targetTime = CMTime(seconds: currentTime + time, preferredTimescale: 600)
    let duration = CMTime(seconds: currentDuration, preferredTimescale: 600)
    let minimumTime = CMTime(seconds: 0, preferredTimescale: 600)

    if time > 0 {
      if targetTime > duration {
        let oneSecond = CMTime(seconds: 1, preferredTimescale: 600)
        targetTime = duration - oneSecond
      }
    } else {
      if targetTime < minimumTime {
        targetTime = minimumTime
      }
    }

    player.seek(to: targetTime) { [weak self] _ in
      self?.timeObserver.pause(false)
      self?.state = .active
    }

    refreshPlayerCasePaused()
  }

  private func refreshPlayerCasePaused() {
    // Play and stop stop immediately to refresh the view if `isPaused`.
    self.player.pause()
    player.playImmediately(atRate: currentRate)
    self.showPauseButton = true
  }

  @ViewBuilder func buildSliderForAudio() -> some View {
    AudioSlider(remoteAudio: self)
  }

  // MARK: Private functions

  // Returns true or false, based on if the user is currently dragging the slider's thumb.
  func sliderEditingChanged(editingStarted: Bool) {
    if editingStarted {
      // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
      // with the slider (otherwise it would keep jumping from where they've moved it to, back
      // to where the player is currently at)
      timeObserver.pause(true)
    } else {
      // Editing finished, start the seek
      state = .buffering
      let targetTime = CMTime(seconds: currentTime,
                              preferredTimescale: 600)
      player.seek(to: targetTime) { [weak self] _ in
        // Now the (async) seek is completed, resume normal operation
        self?.timeObserver.pause(false)
        self?.state = .active
      }
    }
  }

  enum PlaybackState: Int {
    case waitingForSelection
    case buffering
    case active
  }

}

// MARK: - Observers

class PlayerTimeObserver {
  let publisher = PassthroughSubject<TimeInterval, Never>()
  private weak var player: AVPlayer?
  private var timeObservation: Any?
  private var paused = false

  init(player: AVPlayer) {
    self.player = player

    // Periodically observe the player's current time, whilst playing
    timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
                                                     queue: nil) { [weak self] time in
      guard let self = self else { return }
      // If we've not been told to pause our updates
      guard !self.paused else { return }
      // Publish the new player time
      self.publisher.send(time.seconds)
    }
  }

  deinit {
    if let player = player,
       let observer = timeObservation {
      player.removeTimeObserver(observer)
    }
  }

  func pause(_ pause: Bool) {
    paused = pause
  }
}

class PlayerItemObserver {
  let publisher = PassthroughSubject<Bool, Never>()
  private var itemObservation: NSKeyValueObservation?

  init(player: AVPlayer) {
    // Observe the current item changing
    itemObservation = player.observe(\.currentItem) { [weak self] player, _ in
      guard let self = self else { return }
      // Publish whether the player has an item or not
      self.publisher.send(player.currentItem != nil)
    }
  }

  deinit {
    if let observer = itemObservation {
      observer.invalidate()
    }
  }
}

class PlayerDurationObserver {
  let publisher = PassthroughSubject<TimeInterval, Never>()
  private var cancellable: AnyCancellable?

  init(player: AVPlayer) {
    let durationKeyPath: KeyPath<AVPlayer, CMTime?> = \.currentItem?.duration
    cancellable = player.publisher(for: durationKeyPath).sink { [weak self] duration in
      guard let self = self else { return }

      guard let duration = duration else { return }
      guard duration.isNumeric else { return }
      self.publisher.send(duration.seconds)
    }
  }

  deinit {
    cancellable?.cancel()
  }
}
