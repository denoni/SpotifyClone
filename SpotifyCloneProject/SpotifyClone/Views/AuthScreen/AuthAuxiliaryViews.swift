//
//  AuthAuxiliaryViews.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {
  @Binding var isLoading: Bool
  var content: () -> Content

  var body: some View {
    GeometryReader { _ in
      ZStack {
        self.content()
        Group {
          Color.spotifyDarkGray
            .ignoresSafeArea()
            ProgressView()
              .withSpotifyStyle()
              .scaleEffect(2)
              .padding()
        }
        .opacity(isLoading ? 1 : 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}
