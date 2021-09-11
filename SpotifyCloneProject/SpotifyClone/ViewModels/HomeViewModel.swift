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
    var media: Array<SpotifyMediaContent> = []

    for (title, author, coverImage) in rockClassics {
      media.append(SpotifyMediaContent(title: title, author: author, coverImage: coverImage))
    }
    return SpotifyModel<SpotifyMediaContent>(numberOfMedias: media.count) {
        cardIndex in return media[cardIndex]
    }
  }

  var mediaCollection: Array<SpotifyModel<SpotifyMediaContent>.SpotifyMedia> { homeViewModel.mediaCollection }

}


// TODO: Delete the this temporary var and grab the data from the API

var rockClassics: [(String, String, Image)] = [("Bohemian Rhapsody", "Queen", Image("bohemian-rhapsody-cover")),
                                               ("Back in Black", "AC/DC", Image("back-in-black-cover")),
                                               ("Born in The USA", "Bruce Springsteen", Image("born-in-the-usa-cover")),
                                               ("Fortunate Son", "Creedence Clearwater Revival", Image("fortunate-son-cover")),
                                               ("Hotel California", "Eagles", Image("hotel-california-cover")),
                                               ("Sweet Home Alabama", "Lynyrd Skynyrd", Image("sweet-home-alabama-cover")),
                                               ("Come as You Are", "Nirvana", Image("come-as-you-are-cover")),
                                               ("Final Countdown", "Europe", Image("final-countdown-cover")),
                                               ("November Rain", "Guns N' Roses", Image("november-rain-cover")),]
