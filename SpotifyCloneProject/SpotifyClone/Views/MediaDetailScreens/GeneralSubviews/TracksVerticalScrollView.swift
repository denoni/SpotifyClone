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
  var tracksOrigin: MediaDetailSection
  private var medias: [SpotifyModel.MediaItem] {
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
                MediaDetailAPICalls.AlbumAPICalls.getTracksFromAlbum(mediaDetailVM: mediaDetailVM, loadMoreEnabled: true)
              }
            }
        case .playlist:
          PlaylistItem(audioManager: audioManager, media: media)
            .onAppear {
              if mediaDetailVM.shouldFetchMoreData(basedOn: media, inRelationTo: medias) {
                MediaDetailAPICalls.PlaylistAPICalls.getTracksFromPlaylist(mediaDetailVM: mediaDetailVM, loadMoreEnabled: true)
              }
            }
            .onDisappear {
              mediaDetailVM.deleteImageFromCache(imageURL: media.imageURL)
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

  fileprivate struct AlbumItem: View {
    @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
    @StateObject var audioManager: RemoteAudio
    let media: SpotifyModel.MediaItem
    private var details: SpotifyModel.TrackDetails { SpotifyModel.getTrackDetails(for: media) }

    var body: some View {
      HStack(spacing: Constants.spacingSmall) {
        PlayStopButton(audioManager: audioManager,
                       media: media,
                       size: 60)
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

  fileprivate struct PlaylistItem: View {
    @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
    @StateObject var audioManager: RemoteAudio
    let media: SpotifyModel.MediaItem

    @State var isTapped = false
    private var isPlaying: Bool { audioManager.showPauseButton && audioManager.lastItemPlayedID == media.id }
    private var details: SpotifyModel.TrackDetails { SpotifyModel.getTrackDetails(for: media) }
    private var lowestResImageURL: String {
      if media.lowResImageURL != "" {
        return media.lowResImageURL ?? ""
      } else {
        return media.imageURL
      }
    }

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
              .overlay(RemoteImage(urlString: lowestResImageURL))
            PlayStopButton(audioManager: audioManager,
                           media: media,
                           size: 60)
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
      .onChange(of: isPlaying) { _ in
        if !isPlaying { isTapped = false }
      }
    }
  }
}
