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
    GeometryReader { geometry in
      self.content()
        .blur(radius: self.isLoading ? 5 : 0)

      VStack(alignment: .center) {
        VStack(alignment: .center) {
          ProgressView()
            .scaleEffect(2)
            .padding()
          Text("Loading...")
            .font(.title3)

        }
        .frame(width: geometry.size.width / 2,
               height: geometry.size.height / 5)
        .background(Color.black.opacity(0.4))
        .foregroundColor(Color.white)
        .cornerRadius(20)

      }
      .opacity(isLoading ? 1 : 0)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

