//
//  PopularPodcastSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct PopularPodcastSection: View {
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
