//
//  ExplicitIcon.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct ExplicitIcon: View {
  var isExplicit: Bool
  var body: some View {

    RoundedRectangle(cornerRadius: Constants.radiusSmall)
      .foregroundColor(.white)
      .overlay(Text("E")
                .font(.system(size: Constants.fontXSmall))
                .foregroundColor(.black)
                .padding(1))
      .aspectRatio(1/1, contentMode: .fit)
      .opacity(isExplicit ? 1 : 0)
      .frame(width: isExplicit ? 22 : 0, height: isExplicit ? 22 : 0)
  }
}
