//
//  TracksVerticalScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct TracksVerticalScrollView: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @StateObject var audioManager = RemoteAudio()
  var tracksOrigin: MediaDetailViewModel.Section
  var medias: [SpotifyModel.MediaItem] {
    switch tracksOrigin {
    case .album:
      return mediaDetailVM.mediaCollection[.album(.tracksFromAlbum)]!
    case .playlist:
      return mediaDetailVM.mediaCollection[.playlist(.tracksFromPlaylist)]!
    default:
      fatalError("")
    }
  }

  var body: some View {
    LazyVStack {
      ForEach(medias) { media in
        switch tracksOrigin {
        case .album:
          AlbumItem(audioManager: audioManager, media: media)
            .onAppear { testIfShouldFetchMoreData(basedOn: media) }
        case .playlist:
          PlaylistItem(audioManager: audioManager, media: media)
            .onAppear { testIfShouldFetchMoreData(basedOn: media) }
        default:
          fatalError("Media type(\(tracksOrigin)) shouldn't be used here")
        }
      }
    }
    .padding(.top, 15)
  }

  func testIfShouldFetchMoreData(basedOn media: SpotifyModel.MediaItem) {
    if medias.count > 5 {
      if media.id == medias[medias.count - 4].id {
        if tracksOrigin == .album(.tracksFromAlbum) {
          MediaDetailViewModel.AlbumAPICalls.getTracksFromAlbum(mediaVM: mediaDetailVM, loadMoreEnabled: true)
        } else {
          MediaDetailViewModel.PlaylistAPICalls.getTracksFromPlaylist(mediaVM: mediaDetailVM, loadMoreEnabled: true)
        }
      }
    }
  }



  // MARK: - Album Item

  struct AlbumItem: View {
    @StateObject var audioManager: RemoteAudio
    let media: SpotifyModel.MediaItem

    var body: some View {
      HStack(spacing: 12) {
        PlayStopButton(audioManager: audioManager,
                       media: media)
        VStack(alignment: .leading) {
          Text(media.title)
            .font(.avenir(.medium, size: 20))
          Text(media.authorName.joined(separator: ", "))
            .font(.avenir(.medium, size: 16))
            .opacity(0.6)
        }
        .padding(.trailing, 25)
        Spacer()
        Image("three-dots")
          .resizeToFit()
          .padding(.vertical, 16)
      }
      .frame(height: 60)
      .padding(.bottom, 5)
    }
  }



  // MARK: - Playlist Item

  struct PlaylistItem: View {
    @StateObject var audioManager: RemoteAudio

    @State var isTapped = false
    var isPlaying: Bool { audioManager.showPauseButton && audioManager.lastItemPlayedID == media.id }

    let media: SpotifyModel.MediaItem

    var body: some View {
      ZStack {

        // Small color accent in the background of the tapped item
        Color.spotifyLightGray.opacity(0.3)
          .padding(.vertical, -5)
          .padding(.horizontal, -25)
          .opacity(isTapped ? 1 : 0)

        HStack {
          ZStack(alignment: .center) {
            Rectangle()
              .foregroundColor(.spotifyMediumGray)
              .overlay(RemoteImage(urlString: media.imageURL))
            PlayStopButton(audioManager: audioManager,
                           media: media)
                .shadow(color: Color.spotifyDarkGray, radius: 10)
                .padding(.leading, 10)
                .opacity(isTapped ? 1 : 0)
          }
          .frame(width: 60, height: 60)

          VStack(alignment: .leading) {
            Text(media.title)
              .font(.avenir(.medium, size: 20))
            Text(media.authorName.joined(separator: ", "))
              .font(.avenir(.medium, size: 16))
              .opacity(0.7)
          }
          .padding(.trailing, 25)
          Spacer()
          Image("three-dots")
            .resizeToFit()
            .padding(.vertical, 16)
        }
        .frame(height: 60)
        .onTapGesture {
          isTapped = true
          // If after 3 seconds the tapped item was not played,
          // stop marking it as `isTapped`
          DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            guard isPlaying else {
              isTapped = false
              return
            }
          }
        }
      }
      .onChange(of: isPlaying) { response in
        if !isPlaying { isTapped = false }
      }
    }
  }



  // MARK: - Media Controller View

  struct PlayStopButton: View {
    @StateObject var audioManager: RemoteAudio
    var media: SpotifyModel.MediaItem

    var body: some View {
      ZStack {
        if audioManager.state == .buffering {
          ProgressView()
            .scaledToFit()
        } else {
          if audioManager.showPauseButton
              && audioManager.lastItemPlayedID == media.id {
            Image("stop")
              .resizeToFit()
              .onTapGesture {
                audioManager.pause()
              }
          } else {
            Image("play")
              .resizeToFit()
              .padding(.leading, 3)
              .onTapGesture {
                if media.previewURL.isEmpty {
                  audioManager.playWithItunes(forItem: media,
                                              canPlayMoreThanOneAudio: true)
                } else {
                  audioManager.pause()
                  audioManager.play(media.previewURL, audioID: media.id)
                }
              }
          }
        }
      }
      .frame(width: 25, height: 25)
      .padding(.trailing, 10)
    }
  }

}



