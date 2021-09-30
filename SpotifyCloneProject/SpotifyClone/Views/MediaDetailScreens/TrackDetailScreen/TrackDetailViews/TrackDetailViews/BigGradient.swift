//
//  BigGradient.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct BigGradient: View {
  @EnvironmentObject var mediaDetailViewModel: MediaDetailViewModel
  var color: Color {
    return Color(mediaDetailViewModel.imageColorModel.image!.averageColor!)
  }

  var body: some View {
    LinearGradient(gradient: Gradient(colors: [color.opacity(0.8),
                                               color.opacity(0.4),
                                               color.opacity(0.0)]),
                   startPoint: .top,
                   endPoint: .bottom)
  }
}
