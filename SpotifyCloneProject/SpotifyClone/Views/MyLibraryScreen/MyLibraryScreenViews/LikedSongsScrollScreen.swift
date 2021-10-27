//
//  TracksPreviewScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import SwiftUI

struct LikedSongsScrollScreen: View {
  @EnvironmentObject var myLibraryVM: MyLibraryViewModel
  @State var scrollViewPosition = CGFloat.zero
  let likedSongsPlaylistCoverColor = Color(UIColor(red: 0.271, green: 0.192, blue: 0.918, alpha: 1))

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ReadableScrollView(currentPosition: $scrollViewPosition) {
          VStack {
            // 4 is just a ratio that looked visually good
            TopGradient(height: geometry.size.height / 4, specificColor: likedSongsPlaylistCoverColor)
            LikedSongsDetailContent(scrollViewPosition: $scrollViewPosition)
              .padding(.top, -geometry.size.height / 4)
              .padding(.bottom, Constants.paddingBottomSection)
          }
        }
        TopBarWithTitle(scrollViewPosition: $scrollViewPosition,
                        title: "Liked Songs",
                        backButtonShouldReturnTo: .myLibrary(myLibraryVM: myLibraryVM))
      }
      .ignoresSafeArea()
    }
  }
}

// MARK: - Detail Content
struct LikedSongsDetailContent: View {
  @Environment(\.topSafeAreaSize) var topSafeAreaSize
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Binding var scrollViewPosition: CGFloat

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.spacingMedium) {
      Text("Liked Songs")
        .spotifyTitle()
        .padding(.top, topSafeAreaSize + 60)

      if mediaDetailVM.isLoading[.userLikedFollowedMedia(.userLikedSongs)]! == false
          && mediaDetailVM.userLibraryInfo[.numberOfLikedSongs] != nil {

        Group {
          let numberOfLikedSongs = mediaDetailVM.userLibraryInfo[.numberOfLikedSongs]!
          Text("\(numberOfLikedSongs!) songs")
            .font(.avenir(.medium, size: Constants.fontSmall))
            .opacity(Constants.opacityStandard)
        }

        TracksPreviewVerticalScrollView()
      } else {
        HStack {
          ProgressView()
            .withSpotifyStyle(useDiscreetColors: true)
            .onAppear {
              mediaDetailVM.getUserLikedSongsScreenData()
            }
        }.frame(maxWidth: .infinity, alignment: .center)
        Spacer()
      }
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, Constants.paddingStandard)
    .padding(.vertical, Constants.paddingSmall)
    .onDisappear {
      mediaDetailVM.cleanUserLikedFollowedSections()
    }
  }
}

struct TracksPreviewVerticalScrollView: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @StateObject var audioManager = RemoteAudio()
  var medias: [SpotifyModel.MediaItem] { mediaDetailVM.mediaCollection[.userLikedFollowedMedia(.userLikedSongs)]! }

  var body: some View {
    LazyVStack {
      ForEach(medias) { media in
        TrackPreviewItem(media: media, audioManager: audioManager)
          .padding(.bottom, Constants.paddingSmall)
          .onAppear {
            if mediaDetailVM.shouldFetchMoreData(basedOn: media, inRelationTo: medias) {
              MediaDetailAPICalls.UserLikedFollowedMediaAPICalls.getLikedSongs(mediaDetailVM: mediaDetailVM)
            }
          }
      }
    }
    .padding(.top, Constants.paddingSmall)
    .padding(.bottom, Constants.paddingStandard)
  }
}

struct TrackPreviewItem: View {
  let media: SpotifyModel.MediaItem
  @StateObject var audioManager: RemoteAudio

  var body: some View {
    HStack(spacing: Constants.spacingSmall) {
      ZStack {
        RoundedRectangle(cornerRadius: Constants.radiusStandard)
          .foregroundColor(.spotifyLightGray)
        HStack {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(ZStack {
              RemoteImage(urlString: media.imageURL).aspectRatio(1/1, contentMode: .fill)
              PlayStopButton(audioManager: audioManager, media: media, size: 80)
            })
            .frame(width: 80, height: 80)
            .mask(Rectangle().frame(width: 80, height: 80))
          VStack(alignment: .leading, spacing: 5) {
            Text(media.title)
              .font(.avenir(.heavy, size: Constants.fontSmall))
              .lineLimit(1)
              .padding(.trailing, Constants.paddingLarge)
            Text(media.authorName.joined(separator: ", "))
              .font(.avenir(.medium, size: Constants.fontXSmall))
              .opacity(Constants.opacityHigh)
              .lineLimit(1)
          }
          Spacer()
          Image("three-dots")
            .resizeToFit()
            .frame(width: 25)
            .padding(.horizontal, Constants.paddingStandard)
        }
        .mask(RoundedRectangle(cornerRadius: Constants.radiusStandard))
      }
    }
    .frame(maxWidth: .infinity)
  }
}
