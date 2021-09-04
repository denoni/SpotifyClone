//
//  BrowseAllSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

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
