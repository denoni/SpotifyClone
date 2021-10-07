//
//  MediaTitle.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct MediaTitle: View {
  let mediaTitle: String
  var useSmallerFont: Bool = false

  var body: some View {
    VStack(alignment: .leading) {
      Text(mediaTitle)
        .font(.avenir(.black, size: useSmallerFont ? 22 : 26))
        .foregroundColor(.white)
        .lineLimit(2)
    }
  }
}
