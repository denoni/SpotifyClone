//
//  ShowEpisodesScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct ShowEpisodesScrollView: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @StateObject var audioManager = RemoteAudio()
  // This is not the cache. It's just a helper variable to keep track of what and when should the cache be cleaned.
  @State var currentCachedURLs = [String]()

  private var medias: [SpotifyModel.MediaItem] {
    mediaDetailVM.mediaCollection[.shows(.episodesFromShow)]!
  }

  var body: some View {
    LazyVStack {
      ForEach(medias) { media in
        Group {
          let episodeDetails = SpotifyModel.getEpisodeDetails(for: media)
          EpisodeItem(audioManager: audioManager, media: media, details: episodeDetails)
            .onAppear {

              // TODO: Find a way to do it without performance issues
              // Disabled the call below because it causes hitches when user scroll really fast.
//              MediaDetailAPICalls.UserInfoAPICalls.checksIfUserFollows(.episode, mediaDetailVM: mediaDetailVM, itemID: media.id)

              if mediaDetailVM.shouldFetchMoreData(basedOn: media, inRelationTo: medias) {
                MediaDetailAPICalls.ShowsAPICalls.getEpisodesFromShows(mediaDetailVM: mediaDetailVM,
                                                                       loadMoreEnabled: true)
              }
              currentCachedURLs.append(media.imageURL)
            }
            .onDisappear {
              if currentCachedURLs.count > 15 {
                for index in 0..<8 {
                  mediaDetailVM.deleteImageFromCache(imageURL: currentCachedURLs[index])
                  currentCachedURLs.removeFirst()
                }
              }
            }
            .onTapGesture {
              Utility.changeSubpage(to: .episodeDetail, mediaDetailVM: mediaDetailVM, withData: media)
            }
        }
      }
    }
    .padding(.top, Constants.paddingSmall)
  }
}

// MARK: - Episode Item
struct EpisodeItem: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @StateObject var audioManager: RemoteAudio
  let media: SpotifyModel.MediaItem
  let details: SpotifyModel.EpisodeDetails

  var releaseDate: String { Utility.getSpelledOutDate(from: details.releaseDate) }
  var duration: String { Utility.formatTimeToHourMinSec(for: .milliseconds(details.durationInMs), spelledOut: true) }
  var isPlaying: Bool { audioManager.showPauseButton && audioManager.lastItemPlayedID == media.id }

  var followingState: MediaDetailViewModel.CurrentFollowingState {
    guard mediaDetailVM.followedIDs[media.id] != nil else { return .isNotFollowing }
    return mediaDetailVM.followedIDs[media.id]!
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.spacingSmall) {
      HStack(alignment: .center, spacing: Constants.spacingMedium) {
          RoundedRectangle(cornerRadius: Constants.radiusSmall)
            .foregroundColor(.spotifyMediumGray)
            .overlay(RemoteImage(urlString: media.lowResImageURL != "" ? media.lowResImageURL! : media.imageURL))
            .mask(RoundedRectangle(cornerRadius: Constants.radiusSmall))
            .frame(width: 50, height: 50)
          Text(media.title)
            .font(.avenir(.heavy, size: Constants.fontMedium))
          Spacer()
        }

      Group {

        Text(details.description!)
          .font(.avenir(.medium, size: Constants.fontXSmall))
          .lineLimit(2)
          .opacity(Constants.opacityStandard)
          .padding(.bottom, 5)
      }

      Text("\(releaseDate) • \(duration)")
        .font(.avenir(.medium, size: Constants.fontXSmall))
        .opacity(Constants.opacityHigh)
        .padding(.bottom, 5)

      HStack(spacing: Constants.paddingStandard) {
        Group {
          SaveButton(mediaDetailVM: mediaDetailVM,
                     itemID: media.id,
                     itemType: .episode)
          Image("download-circle")
            .resizable()
            .frame(width: 25, height: 25)
          Image("three-dots")
            .resizable()
            .frame(width: 22, height: 22)
            .opacity(Constants.opacityStandard)
        }
        Spacer()
        Circle()
          .foregroundColor(.black)
          .overlay(Image(isPlaying ? "circle-stop" : "circle-play").resizeToFit())
          .aspectRatio(contentMode: .fit)
          .frame(height: 35)
          .onTapGesture {
            if isPlaying {
              audioManager.pause()
            } else {
              audioManager.pause()
              audioManager.play(media.previewURL, audioID: media.id)
            }
          }
      }
      .frame(height: 25, alignment: .leading)
      Divider()
        .padding(.top, 5)
    }
    .frame(height: 200)
  }
}
