//
//  SmallTopSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct SmallTopSection: View {
  var homeViewModel: HomeViewModel
  var albumName: String

  var body: some View {
    HStack {
      Image("down-arrow")
        .resizeToFit()
        .rotationEffect(Angle.degrees(90))
        .padding(.vertical, 3)
        .padding(.horizontal, -5)
        .onTapGesture {
          homeViewModel.goToNoneSubpage()
          // When the trackDetailsScreen is closed, reopen the mediaPlayer.
          homeViewModel.mainViewModel.showBottomMediaPlayer = true
        }
      Spacer()
      VStack {
        Text(albumName)
          .font(.avenir(.heavy, size: 16))
          .frame(maxWidth: .infinity)
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 25)
      Spacer()
      Image("three-dots")
        .resizeToFit()
        .padding(.vertical, 3)
    }
    .frame(height: 30,
           alignment: .center)
    .padding(.bottom, 25)
    .padding(.top, 25)
  }
}
