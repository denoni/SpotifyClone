//
//  ProgressView+SpotifyStyle.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/21/21.
//

import SwiftUI

extension ProgressView {

  @ViewBuilder
  func withSpotifyStyle(size: Int = 100) -> some View {
    self.progressViewStyle(SpotifyProgressViewStyle(size: CGFloat(size)))
  }
}

struct SpotifyProgressViewStyle: ProgressViewStyle {
  var size: CGFloat
  private(set) var stroke: CGFloat = 2
  @State private(set) var centralScale: CGFloat = 1
  @State private(set) var degrees: Double = 0.0

  func makeBody(configuration: Configuration) -> some View {
    ZStack {
      Group {
        Circle()
          .fill(Color.white.opacity(0))
          .overlay(Image("spotify-logo-white")
                    .resizeToFit()
                    .frame(width: size * 0.15 * centralScale, height: size * 15 * centralScale))
          .onAppear {
            withAnimation(Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true)) {
              centralScale = 2
            }
          }
        Group {
          Circle()
            .stroke(Color.spotifyGreen,
                    style: StrokeStyle(lineWidth: stroke))
            .rotation3DEffect(.degrees(degrees), axis: (x: 1, y: 0, z: 1))
          Circle()
            .stroke(Color.spotifyGreen,
                    style: StrokeStyle(lineWidth: stroke))
            .rotation3DEffect(.degrees(-degrees), axis: (x: 1, y: 1, z: 1))
        }
        .frame(width: size * 0.4, height: size * 0.4)
//        .shadow(color: Color.spotifyGreen, radius: 5)
        .onAppear {
          withAnimation(Animation.easeInOut(duration: 2)
                          .repeatForever(autoreverses: true)) {
            degrees = 720
          }
        }
      }.frame(width: size, height: size)
    }
  }
}
