//
//  TracksPreviewScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import SwiftUI

struct TracksPreviewScreen: View {
  @State var scrollViewPosition = CGFloat.zero
  let likedSongsPlaylistCoverColor = Color(UIColor(red: 0.271, green: 0.192, blue: 0.918, alpha: 1))

  var body: some View {
    GeometryReader { geometry in
      ReadableScrollView(currentPosition: $scrollViewPosition) {
        VStack {
          // 4 is just a ratio that looked visually good
          TopGradient(height: geometry.size.height / 4, specificColor: likedSongsPlaylistCoverColor)
          TracksPreviewDetailContent(scrollViewPosition: $scrollViewPosition)
            .padding(.top, -geometry.size.height / 4)
            .padding(.bottom, Constants.paddingBottomSection)
        }
      }
      .ignoresSafeArea()
    }
  }
}



// MARK: - Detail Content
struct TracksPreviewDetailContent: View {
  @Environment(\.topSafeAreaSize) var topSafeAreaSize
  @EnvironmentObject var myLibraryVM: MyLibraryViewModel
  @Binding var scrollViewPosition: CGFloat

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.spacingMedium) {
      Text("Liked Songs")
        .spotifyTitle()
        .padding(.top, topSafeAreaSize + 60)
      Text("30 songs") // TODO: Add real data
        .font(.avenir(.medium, size: Constants.fontSmall))
        .opacity(Constants.opacityStandard)

      if myLibraryVM.isLoading[.userLikedSongs]! == false {
        TracksPreviewVerticalScrollView(medias: myLibraryVM.mediaCollection[.userLikedSongs]!)
      } else {
        HStack {
          ProgressView()
            .withSpotifyStyle(useDiscreetColors: true)
            .onAppear {
              myLibraryVM.getCurrentUserLikedTracks(accessToken: myLibraryVM.mainVM.authKey!.accessToken)
            }
        }.frame(maxWidth: .infinity, alignment: .center)
        Spacer()
      }
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, Constants.paddingStandard)
    .padding(.vertical, Constants.paddingSmall)
  }
}

struct TracksPreviewVerticalScrollView: View {
  var medias: [SpotifyModel.MediaItem]

  var body: some View {
    LazyVStack {
      ForEach(medias) { media in
        TrackPreviewItem(title: media.title, authorsName: media.authorName, imageURL: media.imageURL)
          .padding(.bottom, Constants.paddingSmall)
      }
    }
    .padding(.top, Constants.paddingSmall)
    .padding(.bottom, Constants.paddingStandard)
  }
}

struct TrackPreviewItem: View {
  let title: String
  let authorsName: [String]
  let imageURL: String

  var body: some View {
    HStack(spacing: Constants.spacingSmall) {
      ZStack {
        RoundedRectangle(cornerRadius: Constants.radiusStandard)
          .foregroundColor(.spotifyLightGray)
        HStack {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(RemoteImage(urlString: imageURL).aspectRatio(1/1, contentMode: .fill))
            .frame(width: 80, height: 80)
            .mask(Rectangle().frame(width: 80, height: 80))
          VStack(alignment: .leading, spacing: 5) {
            Text(title)
              .font(.avenir(.heavy, size: Constants.fontSmall))
              .lineLimit(1)
              .padding(.trailing, Constants.paddingLarge)
            Text(authorsName.joined(separator: ", "))
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
