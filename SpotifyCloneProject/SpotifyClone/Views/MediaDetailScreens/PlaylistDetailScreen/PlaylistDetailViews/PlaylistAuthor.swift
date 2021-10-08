//
//  PlaylistAuthor.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct PlaylistAuthor: View {
  @State var mediaOwner: SpotifyModel.MediaOwner

  var body: some View {
    HStack {
      Circle()
        .foregroundColor(.black)
        // TODO: Get image from api.
        .overlay(Image("spotify-small-logo")
                  .resizable()
                  .scaledToFit()
                  .colorMultiply(.spotifyGreen))
        .frame(width: 25, height: 25)
      Text(mediaOwner.displayName)
        .font(.avenir(.heavy, size: Constants.fontSmall))
      Spacer()
    }
  }
}
