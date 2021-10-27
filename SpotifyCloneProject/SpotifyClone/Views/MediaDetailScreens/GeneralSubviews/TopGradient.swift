//
//  TopGradient.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct TopGradient: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  var userSpecifiedColor: Color?

  var height: CGFloat
  private var color: Color {
    guard userSpecifiedColor == nil else {
      return userSpecifiedColor!
    }

    if mediaDetailVM.imageColorModel.image != nil {
      return Color(mediaDetailVM.imageColorModel.image!.averageColor!)
    } else {
      return .clear
    }
  }

  init(height: CGFloat, specificColor: Color? = nil) {
    self.height = height
    self.userSpecifiedColor = specificColor
  }

  var body: some View {
    Rectangle()
      .fill(LinearGradient(gradient: Gradient(colors: [color.opacity(0.8),
                                                       color.opacity(0.4),
                                                       color.opacity(0.0)]),
                           startPoint: .top,
                           endPoint: .bottom))
      .frame(height: height)
  }
}
