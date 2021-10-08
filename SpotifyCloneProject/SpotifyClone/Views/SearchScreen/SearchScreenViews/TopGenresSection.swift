//
//  TopGenresSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct TopGenresSection: View {
  var title: String

  var body: some View {
    VStack {
      Text(title).font(.avenir(.heavy, size: Constants.fontSmall))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, Constants.paddingStandard)
      VStack(spacing: Constants.paddingStandard) {
        HStack(spacing: Constants.paddingStandard) {
          ColorfulCard(text: "Rock",
                       imageURL: "",
                       color: Color(#colorLiteral(red: 0.5476108789, green: 0.1544825733, blue: 0.5206049085, alpha: 1)))
          ColorfulCard(text: "Pop",
                       imageURL: "",
                       color: Color(#colorLiteral(red: 0.16175375, green: 0.503838925, blue: 1, alpha: 1)))
        }
      }
        .frame(height: 100)
        .padding(.horizontal, Constants.paddingStandard)
    }
    .padding(.bottom, 10)
  }
}
