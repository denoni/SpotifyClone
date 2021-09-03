//
//  SearchScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/2/21.
//

// TODO: Make the custom view structures more usable with arguments when called
// TODO: Make all group of cards just one ColorfulCardsSection

import SwiftUI

struct SearchScreen: View {

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {

        SearchSection()
          .padding(.bottom, paddingSectionSeparation)

        TopGenresSection(title: "Top Genres")
          .padding(.bottom, 10)

        PopularPodcastsSection(title: "Popular Podcast Categories")
          .padding(.bottom, 10)

        BrowseAllSection(title: "Browse All")
          .padding(.bottom, paddingBottomSection)

      }.padding(.vertical, lateralPadding)
    }
  }
}

struct SearchSection: View {
  @State private var searchInput: String = ""

  var body: some View {
    VStack {
      Text("Search").font(.avenir(.heavy, size: 34))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, lateralPadding)
      HStack {
        SpotifyTextField(textInput: $searchInput, placeholder: "Artists, Songs, Podcasts...")
      }
        .frame(height: 50)
        .padding(.horizontal, lateralPadding)
    }
  }
}

struct ColorfulCard: View {
  var text: String
  var image: Image
  var color: Color

  var isPodcast = false

  var getCornerRadius: CGFloat {
    isPodcast ? 10 : 0
  }

  @ViewBuilder
  var body: some View {
    ZStack() {
      RoundedRectangle(cornerRadius: 5)
        .fill(color)
      Text(text)
        .foregroundColor(.white)
        .font(.avenir(.black, size: 18))
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .padding(.trailing, 45)
        .padding(.bottom, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      RoundedRectangle(cornerRadius: getCornerRadius)
        .frame(width: 80, height: 80)
        .overlay(image.resizeToFit().mask(RoundedRectangle(cornerRadius: getCornerRadius)))
        .rotationEffect(Angle(degrees: 25))
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding(.vertical, -5)
        .padding(.horizontal, -20)
        .mask(RoundedRectangle(cornerRadius: 5))
    }
  }
}

struct TopGenresSection: View {
  var title: String

  var body: some View {
    VStack {
      Text(title).font(.avenir(.heavy, size: 18))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, lateralPadding)
      VStack(spacing: lateralPadding) {
        HStack(spacing: lateralPadding) {
          ColorfulCard(text: "Rock",
                       image: Image("bohemian-rhapsody-cover"),
                       color: Color(#colorLiteral(red: 0.5476108789, green: 0.1544825733, blue: 0.5206049085, alpha: 1)))
          ColorfulCard(text: "Pop",
                       image: Image("shape-of-you-cover"),
                       color: Color(#colorLiteral(red: 0.16175375, green: 0.503838925, blue: 1, alpha: 1)))
        }
      }
        .frame(height: 100)
        .padding(.horizontal, lateralPadding)
    }
    .padding(.bottom, 10)
  }
}

struct PopularPodcastsSection: View {
  var title: String

  var body: some View {
    VStack {
      Text(title).font(.avenir(.heavy, size: 18))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, lateralPadding)
      VStack(spacing: lateralPadding) {
        HStack(spacing: lateralPadding) {
          ColorfulCard(text: "Interviews",
                       image: Image("joe-rogan-cover"),
                       color: Color(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)),
                       isPodcast: true)
          ColorfulCard(text: "News",
                       image: Image("the-daily-cover"),
                       color: Color(#colorLiteral(red: 0.2064540572, green: 0.9083342805, blue: 0.6514125017, alpha: 1)),
                       isPodcast: true)
        }
      }
        .frame(height: 100)
        .padding(.horizontal, lateralPadding)
    }
  }
}

struct BrowseAllSection: View {
  var title: String

  var body: some View {
    VStack {
      Text(title).font(.avenir(.heavy, size: 18))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, lateralPadding)
      VStack(spacing: lateralPadding) {
        HStack(spacing: lateralPadding) {
          ColorfulCard(text: "From David Guetta",
                       image: Image("this-is-david-guetta-cover"),
                       color: Color(#colorLiteral(red: 0.7710836391, green: 0.1485622513, blue: 0.5117851418, alpha: 1)))
          ColorfulCard(text: "Your Mixes",
                       image: Image("your-mix-1-cover"),
                       color: Color(#colorLiteral(red: 0.6385955811, green: 0.3077141699, blue: 0.1555032398, alpha: 1)))
        }.frame(height: 100)

        HStack(spacing: lateralPadding) {
          ColorfulCard(text: "Trap",
                       image: Image("we-love-you-tecca-cover"),
                       color: Color(#colorLiteral(red: 0.8175805211, green: 0.3089605689, blue: 0.3218129506, alpha: 1)))
          ColorfulCard(text: "Lofi Vibes",
                       image: Image("late-night-lofi-cover"),
                       color: Color(#colorLiteral(red: 0.1351304452, green: 0.4837267841, blue: 0.828531901, alpha: 1)))
        }.frame(height: 100)

        HStack(spacing: lateralPadding) {
          ColorfulCard(text: "Educational",
                       image: Image("ted-talks-daily-cover"),
                       color: Color(#colorLiteral(red: 0.8459848731, green: 0.1628414072, blue: 0.1232188603, alpha: 1)),
                       isPodcast: true)
          ColorfulCard(text: "From Movies",
                       image: Image("la-casa-de-papel-cover"),
                       color: Color(#colorLiteral(red: 0.6613615402, green: 0.03773510493, blue: 0.01915715324, alpha: 1)))
        }.frame(height: 100)

        HStack(spacing: lateralPadding) {
          ColorfulCard(text: "Top Hits",
                       image: Image("viral-hits-cover"),
                       color: Color(#colorLiteral(red: 0.05443440647, green: 0.597268461, blue: 0.3844484789, alpha: 1)))
          ColorfulCard(text: "Humor",
                       image: Image("need-a-friend-cover"),
                       color: Color(#colorLiteral(red: 0.8087820959, green: 0.3839334611, blue: 0.04637871303, alpha: 1)),
                       isPodcast: true)
        }.frame(height: 100)

        HStack(spacing: lateralPadding) {
          ColorfulCard(text: "Road Trip",
                       image: Image("born-in-the-usa-cover"),
                       color: Color(#colorLiteral(red: 0.6351259351, green: 0.09030804783, blue: 0.1812465191, alpha: 1)))
          ColorfulCard(text: "Good Vibes",
                       image: Image("acoustic-covers-cover"),
                       color: Color(#colorLiteral(red: 0.6880221897, green: 0.5069191707, blue: 0.5290142707, alpha: 1)))
        }.frame(height: 100)

      }
      .padding(.horizontal, lateralPadding)
    }
  }
}




// MARK: - Constants

fileprivate var paddingSectionSeparation: CGFloat = 30
