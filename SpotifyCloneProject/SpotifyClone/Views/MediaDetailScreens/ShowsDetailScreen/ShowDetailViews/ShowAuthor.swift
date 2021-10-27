//
//  ShowAuthor.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct ShowAuthor: View {
  var authorName: String

  var body: some View {
    Text(authorName)
      .font(.avenir(.heavy, size: Constants.fontSmall))
      .lineLimit(2)
      .frame(width: .none)
      .opacity(Constants.opacityStandard)
  }
}
