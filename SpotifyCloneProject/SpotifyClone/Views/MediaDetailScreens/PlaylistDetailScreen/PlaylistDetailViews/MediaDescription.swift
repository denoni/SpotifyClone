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
    // TODO: Description is only implemented in `rewindPlaylists`, implement in all home medias
    // (Will crash if you clicked in a media that is not a `rewindPlaylist`)
    Text(description)
      .opacity(0.9)
  }
}
