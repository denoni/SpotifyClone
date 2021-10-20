//
//  MyLibraryTopBar.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import SwiftUI

struct MyLibraryTopBar: View {
  @Environment(\.topSafeAreaSize) var topSafeAreaSize
  
  var body: some View {
    VStack {
      ZStack {
        Color.spotifyMediumGray
          .shadow(color: .black, radius: 10)
        VStack {
          Spacer()
          HStack(spacing: 10) {
            Circle()
              .fill(Color.spotifyGreen)
              .overlay(Text("G").fontWeight(.bold).foregroundColor(.black))
              .scaledToFit()
            Text("My Library")
              .font(.avenir(.black, size: Constants.fontMedium))
            Spacer()
            Image("search-unselected")
              .resizeToFit()
              .padding(8)
              .opacity(Constants.opacityLow)
            Image(systemName: "plus") // TODO: Use the real icon from Spotify
              .resizeToFit()
              .padding(8)
              .opacity(Constants.opacityLow)
          }
          .frame(height: 35)
          .frame(maxWidth: .infinity)
          .padding(.horizontal, Constants.paddingStandard)
          Spacer()
        }
        .padding(.top, topSafeAreaSize)
      }
      .frame(height: 60 + topSafeAreaSize)
      .frame(maxWidth: .infinity)
      .ignoresSafeArea()
      Spacer()
    }
    .frame(maxHeight: .infinity)
  }
}
