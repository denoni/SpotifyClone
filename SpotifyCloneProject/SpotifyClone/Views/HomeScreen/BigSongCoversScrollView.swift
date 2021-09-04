//
//  BigSongCoverScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct BigSongCoversScrollView: View {
  var body: some View {
    VStack(spacing: spacingSmallItems) {
      Text("Rock Classics")
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top,spacing: spacingBigItems) {
          Spacer(minLength: 5)
          BigSongItem(coverImage: Image("bohemian-rhapsody-cover"),
                        title: "Bohemian Rhapsody",
                        artist: "Queen")
          BigSongItem(coverImage: Image("back-in-black-cover"),
                        title: "Back in Black",
                        artist: "AC/DC")
          BigSongItem(coverImage: Image("born-in-the-usa-cover"),
                        title: "Born in The USA",
                        artist: "Bruce Springsteen")
          BigSongItem(coverImage: Image("fortunate-son-cover"),
                        title: "Fortunate Son",
                        artist: "Creedence Clearwater Revival")
          BigSongItem(coverImage: Image("hotel-california-cover"),
                        title: "Hotel California",
                        artist: "Eagles")
          BigSongItem(coverImage: Image("sweet-home-alabama-cover"),
                        title: "Sweet Home Alabama",
                        artist: "Lynyrd Skynyrd")
          BigSongItem(coverImage: Image("come-as-you-are-cover"),
                        title: "Comer as You Are",
                        artist: "Nirvana")
          BigSongItem(coverImage: Image("final-countdown-cover"),
                        title: "Final Countdown",
                        artist: "Europe")
          BigSongItem(coverImage: Image("november-rain-cover"),
                      title: "November Rain",
                      artist: "Guns N' Roses")
        }
      }
    }
  }
}
