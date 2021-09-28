//
//  MediaTitle.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct MediaTitle: View {
  let mediaTitle: String

  var body: some View {
    VStack(alignment: .leading,
           spacing: 0) {
      Text(mediaTitle)
        .font(.avenir(.black, size: 26))
        .foregroundColor(.white)
        .lineLimit(2)
    }
  }
}
