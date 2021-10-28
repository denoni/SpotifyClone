//
//  YourEpisodesScrollScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/24/21.
//

import SwiftUI

struct YourEpisodesScrollScreen: View {
  @EnvironmentObject var myLibraryVM: MyLibraryViewModel
  @State var scrollViewPosition = CGFloat.zero
  let yourEpisodesPlaylistCoverColor = Color(UIColor(red: 0.396, green: 0.824, blue: 0.427, alpha: 1))

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ReadableScrollView(currentPosition: $scrollViewPosition) {
          VStack {
            // 4 is just a ratio that looked visually good
            TopGradient(height: geometry.size.height / 4, specificColor: yourEpisodesPlaylistCoverColor)
            YourEpisodesDetailContent(scrollViewPosition: $scrollViewPosition)
              .padding(.top, -geometry.size.height / 4)
              .padding(.bottom, Constants.paddingBottomSection)
          }
        }
        TopBarWithTitle(scrollViewPosition: $scrollViewPosition,
                        title: "Your Episodes",
                        backButtonShouldReturnTo: .myLibrary(myLibraryVM: myLibraryVM))
      }
      .ignoresSafeArea()
    }
  }
}

// MARK: - Detail Content
struct YourEpisodesDetailContent: View {
  @Environment(\.topSafeAreaSize) var topSafeAreaSize
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @StateObject var audioManager = RemoteAudio()
  @Binding var scrollViewPosition: CGFloat
  var medias: [SpotifyModel.MediaItem] { mediaDetailVM.mediaCollection[.userLikedFollowedMedia(.userSavedEpisodes)]! }

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.spacingMedium) {
      Text("Your Episodes")
        .spotifyTitle()
        .padding(.top, topSafeAreaSize + 60)

      if mediaDetailVM.isLoading[.userLikedFollowedMedia(.userSavedEpisodes)]! == false
          && mediaDetailVM.userLibraryInfo[.numberOfSavedEpisodes] != nil {

        Group {
          let numberOfSavedEpisodes = mediaDetailVM.userLibraryInfo[.numberOfSavedEpisodes]!
          Text("\(numberOfSavedEpisodes!) episodes")
            .font(.avenir(.medium, size: Constants.fontSmall))
            .opacity(Constants.opacityStandard)
        }

        LazyVStack {
          ForEach(medias) { media in
            Group {
              let episodeDetails = SpotifyModel.getEpisodeDetails(for: media)
              EpisodeItem(audioManager: audioManager, media: media, details: episodeDetails)
                .onAppear {
                  MediaDetailAPICalls.UserInfoAPICalls.checksIfUserFollows(.episode,
                                                                           mediaDetailVM: mediaDetailVM,
                                                                           itemID: media.id)
                }
            }
            .padding(.bottom, Constants.paddingSmall)
            .onAppear {
              if mediaDetailVM.shouldFetchMoreData(basedOn: media, inRelationTo: medias) {
                MediaDetailAPICalls.UserLikedFollowedMediaAPICalls.getUserSavedEpisodes(mediaDetailVM: mediaDetailVM)
              }
            }
          }
        }
        .padding(.top, Constants.paddingSmall)
        .padding(.bottom, Constants.paddingStandard)
      } else {
        HStack {
          ProgressView()
            .withSpotifyStyle(useDiscreetColors: true)
            .onAppear {
              mediaDetailVM.getUserSavedEpisodesScreenData()
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
