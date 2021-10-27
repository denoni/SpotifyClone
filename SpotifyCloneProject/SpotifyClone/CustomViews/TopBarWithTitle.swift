//
//  TopBarWithTitle.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/3/21.
//

import SwiftUI

struct TopBarWithTitle: View {
  @Binding var scrollViewPosition: CGFloat
  var title: String
  var backButtonWithCircleBackground: Bool = false
  var backButtonShouldReturnTo: MediaDetailViewModel.DetailScreenOrigin

  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  private var backgroundOpacity: Double {
    let opacity = Double(scrollViewPosition / UIScreen.main.bounds.height * 2)
    return opacity > Constants.opacityLow ? Constants.opacityLow : opacity
  }

  private var titleOpacity: Double {
    let opacity = Double(log(scrollViewPosition / UIScreen.main.bounds.height * 4))
    return opacity > 1 ? 1 : opacity
  }

  private var circleOpacity: Double {
    let opacity = 1 - Double(scrollViewPosition / UIScreen.main.bounds.height * 2)
    return opacity - 0.7 > Constants.opacityHigh ? Constants.opacityHigh : opacity - 0.7
  }

  var body: some View {
    VStack(alignment: .center) {
      ZStack {
        Rectangle()
          .foregroundColor(.black)
          .frame(height: topSafeAreaSize + 60)
          .frame(maxWidth: .infinity)
          .ignoresSafeArea()
          .opacity(backgroundOpacity)
        HStack {
          if backButtonWithCircleBackground {
            Circle()
              .overlay(BackButton(backButtonShouldReturnTo: backButtonShouldReturnTo)
                        .padding(5)
                        .padding(.trailing, -3)
                        .scaledToFit())
              .foregroundColor(.black.opacity(circleOpacity))
              .frame(width: 35, height: 35)
              .padding(.leading, Constants.paddingStandard)
          } else {
            BackButton(backButtonShouldReturnTo: backButtonShouldReturnTo)
              .frame(width: 30, height: 30, alignment: .center)
              .padding(.leading, Constants.paddingStandard)
          }
          Text(title)
            .font(.avenir(.black, size: Constants.fontMedium))
            .opacity(titleOpacity)
            .lineLimit(1)
            .padding(.leading, Constants.paddingSmall)
            .padding(.trailing, Constants.paddingStandard)
          Spacer()
        }
        .padding(.top, topSafeAreaSize)
        .padding(.top, 10)
      }
      Spacer()
    }
  }
}
