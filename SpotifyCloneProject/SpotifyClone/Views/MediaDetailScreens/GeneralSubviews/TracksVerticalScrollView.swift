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
      fatalError("Media Type '\(tracksOrigin)' is not compatible with TracksVerticalScrollView")
    }
  }

  var body: some View {
    LazyVStack {
      ForEach(medias) { media in
        switch tracksOrigin {
        case .album:
          AlbumItem(audioManager: audioManager, media: media)
            .onAppear {
              if mediaDetailVM.shouldFetchMoreData(basedOn: media, inRelationTo: medias) {
                MediaDetailViewModel.AlbumAPICalls.getTracksFromAlbum(mediaVM: mediaDetailVM, loadMoreEnabled: true)
              }
            }
        case .playlist:
          PlaylistItem(audioManager: audioManager, media: media)
            .onAppear {
              if mediaDetailVM.shouldFetchMoreData(basedOn: media, inRelationTo: medias) {
                MediaDetailViewModel.PlaylistAPICalls.getTracksFromPlaylist(mediaVM: mediaDetailVM, loadMoreEnabled: true)
              }
            }
        default:
          fatalError("Media type(\(tracksOrigin)) shouldn't be used here")
        }
      }
    }
    .padding(.top, Constants.paddingSmall)
    .padding(.bottom, Constants.paddingStandard)
  }



  // MARK: - Album Item

  struct AlbumItem: View {
    @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
    @StateObject var audioManager: RemoteAudio

    let media: SpotifyModel.MediaItem
    var details: SpotifyModel.TrackDetails { SpotifyModel.getTrackDetails(for: media) }

    var body: some View {
      HStack(spacing: Constants.spacingSmall) {
        PlayStopButton(audioManager: audioManager,
                       media: media)
        VStack(alignment: .leading, spacing: 0) {
          Text(media.title)
            .font(.avenir(.medium, size: Constants.fontMedium))
          HStack(spacing: 0) {
            ExplicitIcon(isExplicit: details.explicit)
              .padding(.trailing, details.explicit ? 5 : 0)
              .scaleEffect(0.8)
            Text(media.authorName.joined(separator: ", "))
              .font(.avenir(.medium, size: Constants.fontSmall))
          }
          .opacity(Constants.opacityStandard)
        }
        .padding(.trailing, Constants.paddingStandard)
        Spacer()
        Image("three-dots")
          .resizeToFit()
          .padding(.vertical, Constants.paddingSmall)
      }
      .frame(height: 60)
      .padding(.bottom, 5)
      .padding(.leading, -Constants.paddingSmall)
    }
  }



  // MARK: - Playlist Item

  struct PlaylistItem: View {
    @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
    @StateObject var audioManager: RemoteAudio

    @State var isTapped = false
    var isPlaying: Bool { audioManager.showPauseButton && audioManager.lastItemPlayedID == media.id }
    var details: SpotifyModel.TrackDetails { SpotifyModel.getTrackDetails(for: media) }
    let media: SpotifyModel.MediaItem

    var body: some View {
      ZStack {

        // Small color accent in the background of the tapped item
        Color.spotifyLightGray.opacity(Constants.opacityXHigh)
          .padding(.vertical, -5)
          .padding(.horizontal, -Constants.paddingStandard)
          .opacity(isTapped ? 1 : 0)

        HStack {
          ZStack(alignment: .center) {
            Rectangle()
              .foregroundColor(.spotifyMediumGray)
              .overlay(RemoteImage(urlString: media.imageURL))
            PlayStopButton(audioManager: audioManager,
                           media: media)
                .opacity(isTapped ? 1 : 0)
          }
          .frame(width: 60, height: 60)

          VStack(alignment: .leading, spacing: 0) {
            Text(media.title)
              .font(.avenir(.medium, size: Constants.fontMedium))
            HStack(spacing: 0) {
              ExplicitIcon(isExplicit: details.explicit)
                .padding(.trailing, details.explicit ? 5 : 0)
                .scaleEffect(0.8)
              Text(media.authorName.joined(separator: ", "))
                .font(.avenir(.medium, size: Constants.fontSmall))
            }
            .opacity(Constants.opacityStandard)
          }
          .padding(.trailing, Constants.paddingStandard)
          Spacer()
          Image("three-dots")
            .resizeToFit()
            .padding(.vertical, Constants.fontSmall)
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
        // Add a darkish background to the play/stop button, so
        // it gets more visible even when the cover image is whitish.
        Color.spotifyMediumGray.opacity(0.3)

        // The play/stop/buffering icon
        ZStack(alignment: .center) {
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
      }
      .frame(width: 60, height: 60, alignment: .center)
    }
  }

}



