//
//  BigGradient.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct BigGradient: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  private var color: Color {
    if mediaDetailVM.imageColorModel.image != nil {
      return Color(mediaDetailVM.imageColorModel.image!.averageColor!)
    } else {
      return .clear
    }

  }

  var body: some View {
    LinearGradient(gradient: Gradient(colors: [color.opacity(0.8),
                                               color.opacity(0.4),
                                               color.opacity(0.0)]),
                   startPoint: .top,
                   endPoint: .bottom)
  }
}
