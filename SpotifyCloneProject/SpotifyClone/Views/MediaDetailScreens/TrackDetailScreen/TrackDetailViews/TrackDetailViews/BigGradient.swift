//
//  BigGradient.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct BigGradient: View {
  @ObservedObject var mediaDetailViewModel: MediaDetailViewModel
  @State var color: Color

  init(mediaDetailViewModel: MediaDetailViewModel) {
    self.mediaDetailViewModel = mediaDetailViewModel
    mediaDetailViewModel.imageColorModel = RemoteImageModel(urlString: mediaDetailViewModel.media!.imageURL)
    color = Color(mediaDetailViewModel.imageColorModel.image?.averageColor! ?? .clear)
  }

  var body: some View {
    LinearGradient(gradient: Gradient(colors: [color.opacity(0.8),
                                               color.opacity(0.4),
                                               color.opacity(0.0)]),
                   startPoint: .top,
                   endPoint: .bottom)
  }
}
