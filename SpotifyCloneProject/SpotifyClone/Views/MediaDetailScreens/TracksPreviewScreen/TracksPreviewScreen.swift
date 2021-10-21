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
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Binding var scrollViewPosition: CGFloat

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.spacingMedium) {

      Text("Liked Songs")
        .spotifyTitle()
        .padding(.top, topSafeAreaSize + 60)
      Text("30 songs")
        .font(.avenir(.medium, size: Constants.fontSmall))
        .opacity(Constants.opacityStandard)
      
      Spacer()

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, Constants.paddingStandard)
    .padding(.vertical, Constants.paddingSmall)
  }
}

