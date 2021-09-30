//
//  BackButton.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct BackButton: View {
  @EnvironmentObject var homeVM: HomeViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  var body: some View {
    VStack {
      HStack {
        Image("down-arrow")
          .resizeToFit()
          .rotationEffect(Angle.degrees(90))
        Spacer()
      }
      .frame(height: 20)
      .onTapGesture {
        homeVM.goToNoneSubpage()
      }
    }
  }
}
