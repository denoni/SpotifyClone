//
//  AlbumInfo.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct AlbumInfo: View {
  var releaseDate: String

  var body: some View {
    Text("Album • \(String(releaseDate.prefix(4)))")
      .opacity(0.6)
  }
}
