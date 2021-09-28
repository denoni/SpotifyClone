//
//  MediaDescription.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct MediaDescription: View {
  @State var description: String

  var body: some View {

    Text(description)
      .opacity(0.9)
      .lineLimit(2)
    // TODO: Add a `Read more...` clickable to show the full description
  }
}
