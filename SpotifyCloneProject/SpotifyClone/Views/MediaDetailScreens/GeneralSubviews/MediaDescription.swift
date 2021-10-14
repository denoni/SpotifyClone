//
//  MediaDescription.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct MediaDescription: View {
  @State var description: String
  var lineLimit: Int = 2

  var body: some View {

    Text(description)
      .font(.avenir(.medium, size: Constants.fontSmall))
      .opacity(Constants.opacityStandard)
      .lineLimit(lineLimit)
    // TODO: Add a `Read more...` clickable to show the full description
  }
}
