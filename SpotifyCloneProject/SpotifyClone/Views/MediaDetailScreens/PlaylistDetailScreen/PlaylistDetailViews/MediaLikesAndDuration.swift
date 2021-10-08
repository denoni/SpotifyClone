//
//  MediaLikesAndDuration.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct MediaLikesAndDuration: View {
  @State var playlistTracks: SpotifyModel.PlaylistTracks

  var body: some View {
    Text("\(playlistTracks.numberOfSongs) songs • 1h 22m") // TODO: Get real data
      .opacity(Constants.opacityStandard)
  }
}
