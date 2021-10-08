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
      Text(title).font(.avenir(.heavy, size: Constants.fontSmall))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, Constants.paddingStandard)
      VStack(spacing: Constants.paddingStandard) {
        HStack(spacing: Constants.paddingStandard) {
          ColorfulCard(text: "Interviews",
                       imageURL: "",
                       color: Color(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)),
                       isPodcast: true)
          ColorfulCard(text: "News",
                       imageURL: "",
                       color: Color(#colorLiteral(red: 0.2064540572, green: 0.9083342805, blue: 0.6514125017, alpha: 1)),
                       isPodcast: true)
        }
      }
        .frame(height: 100)
        .padding(.horizontal, Constants.paddingStandard)
    }
  }
}
