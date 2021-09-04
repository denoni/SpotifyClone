//
//  RecommendedArtistScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct RecommendedArtistScrollView: View {
  var body: some View {
    VStack(spacing: spacingSmallItems) {
      HStack(alignment: .top, spacing: spacingSmallItems) {
        Circle()
          .overlay(Image("david-guetta").resizeToFit())
          .aspectRatio(contentMode: .fit)
          .mask(Circle())
          .padding(3)
        VStack(alignment: .center) {
          Spacer()
          Text("FOR THE FANS OF").font(.avenir(.book, size: 14))
            .opacity(0.7)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text("David Guetta")
            .spotifyTitle()
        }.frame(maxWidth: .infinity, alignment: .topLeading)
      }
      .frame(height: 60)
      .aspectRatio(contentMode: .fit)
      .padding(.leading, lateralPadding)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top,spacing: spacingBigItems) {
          Spacer(minLength: 5)
          BigSongItem(coverImage: Image("nothing-but-the-beat-cover"),
                        title: "Nothing But The Beat")
          BigSongItem(coverImage: Image("bed-cover"),
                        title: "BED")
          BigSongItem(coverImage: Image("this-is-david-guetta-cover"),
                        title: "This is David Guetta")
          BigSongItem(coverImage: Image("hero-cover"),
                        title: "Hero")
          BigSongItem(coverImage: Image("memories-cover"),
                        title: "Memories")
          BigSongItem(coverImage: Image("heartbreak-anthem-cover"),
                        title: "Heartbreak Anthem")
          BigSongItem(coverImage: Image("titanium-cover"),
                        title: "Titanium")
        }
      }
    }
  }
}
