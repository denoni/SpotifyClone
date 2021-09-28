//
//  AlbumTracksScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct AlbumTracksScrollView: View {
  let arr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
  var body: some View {
    LazyVStack {
      ForEach(arr, id: \.self) { _ in
        HStack(spacing: 12) {
          VStack(alignment: .leading) {
            Text("Sweetener (Studio Mix)")
              .font(.avenir(.medium, size: 20))
            Text("Ariana Grande")
              .font(.avenir(.medium, size: 16))
              .opacity(0.7)
          }
          Spacer()
          Image("three-dots")
            .resizeToFit()
            .padding(.vertical, 16)
        }
        .frame(height: 60)
      }
    }
    .padding(.top, 15)
  }
}

