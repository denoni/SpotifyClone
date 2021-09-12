//
//  HomeViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import SwiftUI

class HomeViewModel: ObservableObject {
  @Published private var homeViewModel: SpotifyModel<SpotifyMediaContent> = HomeViewModel.getData()

  private static func getData() -> SpotifyModel<SpotifyMediaContent> {
    var allMediaSet = [String:[SpotifyMediaContent]]()

// TODO: The sections below should be added in a non-manual way

    // Rock Classics
    var rockClassicsSection = [SpotifyMediaContent]()
    for (title, author, coverImage) in rockClassics {
      rockClassicsSection.append(SpotifyMediaContent(title: title,
                                              author: author,
                                              coverImage: coverImage))
    }
    allMediaSet["Rock Classics"] = rockClassicsSection

    // Recently Played
    var recentlyPlayedSection = [SpotifyMediaContent]()
    for (title, coverImage, isPodcast, isArtist) in recentlyPlayed {
      recentlyPlayedSection.append(SpotifyMediaContent(title: title,
                                                       author: "",
                                                       coverImage: coverImage,
                                                       isPodcast: isPodcast,
                                                       isArtist: isArtist))
    }
    allMediaSet["Recently Played"] = recentlyPlayedSection

    // SmallSongCardItems
    var smallSongCardSection = [SpotifyMediaContent]()
    for (title, coverImage) in smallSongCardItems {
      smallSongCardSection.append(SpotifyMediaContent(title: title,
                                                      author: "",
                                                      coverImage: coverImage))
    }
    allMediaSet["Small Song Card Items"] = smallSongCardSection

    // Top Podcasts
    var topPodcastsSection = [SpotifyMediaContent]()
    for (title, author, coverImage, isPodcast) in topPodcasts {
      topPodcastsSection.append(SpotifyMediaContent(title: title,
                                              author: author,
                                              coverImage: coverImage,
                                              isPodcast: isPodcast))
    }
    allMediaSet["Top Podcasts"] = topPodcastsSection

    // For The Fans Of David Guetta
    var forTheFansOfDavidGuettaSection = [SpotifyMediaContent]()
    for (title, coverImage) in forTheFansOfDavidGuetta {
      forTheFansOfDavidGuettaSection.append(SpotifyMediaContent(title: title,
                                                                author: "",
                                                                coverImage: coverImage))
    }
    allMediaSet["For The Fans Of David Guetta"] = forTheFansOfDavidGuettaSection


    return SpotifyModel<SpotifyMediaContent>(collectionOfMedia: allMediaSet)
  }



  // MARK: - X

  var mediaCollection: [String:[SpotifyModel<SpotifyMediaContent>.SpotifyMedia]] { homeViewModel.homeScreenMediaCollection }



  // MARK: - Y

  func getItems(fromSection sectionTitle: String) -> [SpotifyModel<SpotifyMediaContent>.SpotifyMedia] {

    guard self.mediaCollection.keys.contains(sectionTitle) else {
      fatalError("Provided section title does not exist.")
    }

    return self.mediaCollection[sectionTitle]!
  }
}



// TODO: Delete the this temporary var and grab the data from the API

                // (title, artist, image)
var rockClassics: [(String, String, Image)] = [
   ("Bohemian Rhapsody", "Queen", Image("bohemian-rhapsody-cover")),
   ("Back in Black", "AC/DC", Image("back-in-black-cover")),
   ("Born in The USA", "Bruce Springsteen", Image("born-in-the-usa-cover")),
   ("Fortunate Son", "Creedence Clearwater Revival", Image("fortunate-son-cover")),
   ("Hotel California", "Eagles", Image("hotel-california-cover")),
   ("Sweet Home Alabama", "Lynyrd Skynyrd", Image("sweet-home-alabama-cover")),
   ("Come as You Are", "Nirvana", Image("come-as-you-are-cover")),
   ("Final Countdown", "Europe", Image("final-countdown-cover")),
   ("November Rain", "Guns N' Roses", Image("november-rain-cover")),
]

             // (title, image, isArtist, isPodcast)
var recentlyPlayed: [(String, Image, Bool, Bool)] = [
  ("Hip Hop Controller", Image("hip-hop-controller-cover"), false, false),
  ("IU", Image("iu-cover"), true, false),
  ("Liked Songs", Image("liked-songs-cover"), false, false),
  ("Late Night Lofi", Image("late-night-lofi-cover"), false, false),
  ("Lex Fridman Podcast", Image("lex-fridman-cover"), false, true),
  ("We Love You Tecca", Image("we-love-you-tecca-cover"), false, false),
  ("AVICII", Image("avicii-cover"), true, false),
  ("Sweetener", Image("sweetener-cover"), false, false),
  ("Viral Hits", Image("viral-hits-cover"), false, false),
]
                     // (title, coverImage)
var smallSongCardItems: [(String, Image)] = [
  ("Shape of You", Image("shape-of-you-cover")),
  ("Prayer in C", Image("prayer-in-c-cover")),
  ("La Casa de Papel Soundtrack", Image("la-casa-de-papel-cover")),
  ("This is Logic", Image("this-is-logic-cover")),
  ("Your Mix 1", Image("your-mix-1-cover")),
  ("Bohemian Rhapsody", Image("bohemian-rhapsody-cover")),
]
             // (title, author, coverImage, isPodcast)
var topPodcasts: [(String, String, Image, Bool)] = [
  ("Joe Rogan Experience", "Joe Rogan", Image("joe-rogan-cover"), true),
  ("The Daily", "The New York Times", Image("the-daily-cover"), true),
  ("Dateline", "NBC News", Image("dateline-cover"), true),
  ("Distractible", "Wood Elf", Image("distractible-cover"), true),
  ("Ted Talks Daily", "TED", Image("ted-talks-daily-cover"), true),
  ("Smartless", "Jason Bateman, Sean Hayes, Will Arnett", Image("smartless-cover"), true),
  ("Lex Fridman Podcast", "Lex Fridman", Image("lex-fridman-cover"), true),
  ("You're Wrong About", "Michael Hobbes & Sarah Marshall", Image("youre-wrong-cover"), true),
  ("Conan O'Brien Need a Friend", "Team Coco & Earwolf", Image("need-a-friend-cover"), true),
]

// (title, coverImage)
var forTheFansOfDavidGuetta: [(String, Image)] = [
  // ITEM 0 = Artist from the collection
  ("David Guetta", Image("david-guetta")),
  ("Nothing But The Beat", Image("nothing-but-the-beat-cover")),
  ("BED", Image("bed-cover")),
  ("This is David Guetta", Image("this-is-david-guetta-cover")),
  ("Hero", Image("hero-cover")),
  ("Memories", Image("memories-cover")),
  ("Heartbreak Anthem", Image("heartbreak-anthem-cover")),
  ("Titanium", Image("titanium-cover")),
]
