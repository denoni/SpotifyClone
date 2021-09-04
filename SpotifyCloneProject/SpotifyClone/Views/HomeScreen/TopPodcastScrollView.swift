//
//  TopPodcastScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct TopPodcastScrollView: View {
  var body: some View {
    VStack(spacing: spacingSmallItems) {
      Text("Top Podcasts")
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top,spacing: spacingBigItems) {
          Spacer(minLength: 5)
          BigSongItem(coverImage: Image("joe-rogan-cover"),
                        title: "Joe Rogan Experience",
                        artist: "Joe Rogan",
                        isPodcast: true)
          BigSongItem(coverImage: Image("the-daily-cover"),
                        title: "The Daily",
                        artist: "The New York Times",
                        isPodcast: true)
          BigSongItem(coverImage: Image("dateline-cover"),
                        title: "Dateline",
                        artist: "NBC News",
                        isPodcast: true)
          BigSongItem(coverImage: Image("distractable-cover"),
                        title: "Distractable",
                        artist: "Wood Elf",
                        isPodcast: true)
          BigSongItem(coverImage: Image("ted-talks-daily-cover"),
                        title: "Ted Talks Daily",
                        artist: "TED",
                        isPodcast: true)
          BigSongItem(coverImage: Image("smartless-cover"),
                        title: "Smartless",
                        artist: "Jason Bateman, Sean Hayes, Will Arnett",
                        isPodcast: true)
          BigSongItem(coverImage: Image("lex-fridman-cover"),
                        title: "Lex Fridman Podcast",
                        artist: "Lex Fridman",
                        isPodcast: true)
          BigSongItem(coverImage: Image("youre-wrong-cover"),
                        title: "You're Wrong About",
                        artist: "Michael Hobbes & Sarah Marshall",
                        isPodcast: true)
          BigSongItem(coverImage: Image("need-a-friend-cover"),
                        title: "Conan O'Brien Need a Friend",
                        artist: "Team Coco & Earwolf",
                        isPodcast: true)
        }
      }
    }
  }
}
