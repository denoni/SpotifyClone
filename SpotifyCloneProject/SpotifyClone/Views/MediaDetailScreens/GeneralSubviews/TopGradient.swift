//
//  TopGradient.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct TopGradient: View {
  @EnvironmentObject var mediaDetailViewModel: MediaDetailViewModel

  var height: CGFloat
  var color: Color {
    return Color(mediaDetailViewModel.imageColorModel.image!.averageColor!)
  }

  init(height: CGFloat) {
    self.height = height
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
