//
//  ShowAuthor.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct ShowAuthor: View {
  @State var authorName: String

  var body: some View {
    Text(authorName)
      .font(.avenir(.heavy, size: 16))
      .lineLimit(2)
      .frame(width: .none)
      .opacity(0.6)
  }
}

