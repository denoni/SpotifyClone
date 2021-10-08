//
//  BigArtistNameTitle.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct BigArtistNameTitle: View {
  var name: String

  var body: some View {
    HStack {
      Text(name)
        .font(.avenir(.black, size: Constants.fontXXLarge))
        .padding(.top, Constants.paddingStandard)
        .padding(.bottom, Constants.paddingSmall)
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
        .lineLimit(3)
      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}
