//
//  RecentlyPlayedScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct RecentlyPlayedScrollView: View {
  var body: some View {
    VStack(spacing: spacingSmallItems) {
      Text("Recently Played")
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top, spacing: spacingBigItems) {
          Spacer(minLength: 5)
          SmallSongItem(coverImage: Image("hip-hop-controller-cover"),
                        title: "Hip Hop Controller")
          SmallSongItem(coverImage: Image("iu-cover"),
                        title: "IU",
                        isArtistProfile: true)
          SmallSongItem(coverImage: Image("liked-songs-cover"),
                        title: "Liked Songs")
          SmallSongItem(coverImage: Image("late-night-lofi-cover"),
                        title: "Late Night Lofi")
          SmallSongItem(coverImage: Image("we-love-you-tecca-cover"),
                        title: "We Love You Tecca")
          SmallSongItem(coverImage: Image("avicii-cover"),
                        title: "AVICII",
                        isArtistProfile: true)
          SmallSongItem(coverImage: Image("sweetener-cover"),
                        title: "Sweetener")
          SmallSongItem(coverImage: Image("viral-hits-cover"),
                        title: "Viral Hits")
        }
      }
    }
  }
}
