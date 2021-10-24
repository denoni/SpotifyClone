//
//  SmallTopSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct SmallTopSection: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  var albumName: String
  var isSmallDisplay: Bool = false

  var body: some View {
    HStack {
      // Rotate the down-arrow to turn it into a left arrow
      Image("down-arrow")
        .resizeToFit()
        .rotationEffect(Angle.degrees(90))
        .padding(.vertical, 3)
        .padding(.horizontal, -5)
        .onTapGesture {
          Utility.goToPreviousPage(mediaDetailVM: mediaDetailVM)
        }
      Spacer()
      VStack {
        Text(albumName)
          .font(.avenir(.heavy, size: Constants.fontSmall))
          .frame(maxWidth: .infinity)
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, Constants.paddingStandard)
      Spacer()
      Image("three-dots")
        .resizeToFit()
        .padding(.vertical, 3)
    }
    .frame(height: isSmallDisplay ? 25 : 30, alignment: .center)
  }
}
