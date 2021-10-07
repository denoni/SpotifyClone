//
//  SmallTopSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct SmallTopSection: View {
  @EnvironmentObject var homeVM: HomeViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  var albumName: String
  var isSmallDisplay: Bool = false

  var body: some View {
    HStack {
      Image("down-arrow")
        .resizeToFit()
        .rotationEffect(Angle.degrees(90))
        .padding(.vertical, 3)
        .padding(.horizontal, -5)
        .onTapGesture {
          homeVM.goToNoneSubpage()
          // When the trackDetailsScreen is closed, reopen the mediaPlayer.
          homeVM.mainVM.showBottomMediaPlayer = true
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
    .frame(height: isSmallDisplay ? 25 : 30, alignment: .center)
    .border(Color.white)
  }
}
