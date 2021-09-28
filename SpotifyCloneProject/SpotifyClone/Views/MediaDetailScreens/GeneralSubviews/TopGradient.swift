//
//  TopGradient.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct TopGradient: View {
  @ObservedObject var mediaDetailViewModel: MediaDetailViewModel

  var height: CGFloat
  @State var color: Color

  init(mediaDetailViewModel: MediaDetailViewModel, height: CGFloat) {
    self.mediaDetailViewModel = mediaDetailViewModel
    self.height = height
    mediaDetailViewModel.imageColorModel = RemoteImageModel(urlString: mediaDetailViewModel.media!.imageURL)
    color = Color(mediaDetailViewModel.imageColorModel.image?.averageColor! ?? .clear)
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
