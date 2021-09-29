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
        .font(.avenir(.black, size: 45))
        .padding(.top, 25)
        .padding(.bottom, 15)
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
        .lineLimit(3)
      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}
