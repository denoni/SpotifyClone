//
//  ArtistAlbums.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistAlbums: View {
  let arr = [1,2,3,4,5]

  var body: some View {
    VStack {
      ForEach(arr, id: \.self) { _ in
        HStack(spacing: 12) {
          VStack(alignment: .leading) {
            Text("Sweetener (Studio Mix)")
              .font(.avenir(.medium, size: 18))
            Text("Album • 2020")
              .font(.avenir(.medium, size: 14))
              .opacity(0.7)
          }
          Spacer()
        }
        .padding(.top, 5)
      }
      SeeMoreButton()
        .padding(.top, 10)
        .opacity(0.7)
    }
  }
}
