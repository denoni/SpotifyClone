//
//  BackButtonWithCircleBackground.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct BackButtonWithCircleBackground: View {

  var body: some View {
    VStack {
      Circle()
        .overlay(BackButton()
                  .padding(5)
                  .padding(.trailing, -3)
                  .scaledToFit())
        .foregroundColor(.black.opacity(0.3))
        .frame(width: 35, height: 35)
      Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(25)
    .padding(.top, 40)
  }
}
