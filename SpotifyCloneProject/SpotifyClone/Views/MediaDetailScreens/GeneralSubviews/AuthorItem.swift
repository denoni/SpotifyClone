//
//  AuthorItem.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/14/21.
//

import SwiftUI

struct AuthorItem: View {
  var name: String
  var id: String
  var imageURL: String
  var isPodcast: Bool = false

  @ViewBuilder private var imageFormat: some View {
    if isPodcast {
      RoundedRectangle(cornerRadius: Constants.radiusSmall)
    } else {
      Circle()
    }
  }

  var body: some View {
    HStack {
      Circle()
        .foregroundColor(.spotifyDarkGray)
        .overlay(RemoteImage(urlString: imageURL).mask(imageFormat))
        .frame(width: 25, height: 25)
      Text(name)
        .font(.avenir(.heavy, size: 16))
        .lineLimit(2)
        .frame(width: .none)
    }
  }
}
