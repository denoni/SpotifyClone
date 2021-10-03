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

  var backgroundOpacity: Double {
    let opacity = Double(scrollViewPosition / UIScreen.main.bounds.height * 2)
    return opacity > 0.8 ? 0.8 : opacity
  }

  var titleOpacity: Double {
    let opacity = Double(log(scrollViewPosition / UIScreen.main.bounds.height * 4))
    return opacity > 0.8 ? 0.8 : opacity
  }

  var circleOpacity: Double {
    let opacity = 1 - Double(scrollViewPosition / UIScreen.main.bounds.height * 2)
    print(opacity)
    return opacity - 0.7 > 0.3 ? 0.3 : opacity - 0.7
  }

  var body: some View {
    VStack(alignment: .center) {
      ZStack {
        Rectangle()
          .foregroundColor(.black)
          .frame(height: 100)
          .frame(maxWidth: .infinity)
          .ignoresSafeArea()
          .opacity(backgroundOpacity)
        HStack(spacing: 15) {
          if backButtonWithCircleBackground {
            Circle()
              .overlay(BackButton()
                        .padding(5)
                        .padding(.trailing, -3)
                        .scaledToFit())
              .foregroundColor(.black.opacity(circleOpacity))
              .frame(width: 35, height: 35)
          } else {
            BackButton()
              .aspectRatio(contentMode: .fit)
          }
          Text(title)
            .font(.avenir(.black, size: 20))
            .opacity(titleOpacity > 0.8 ? 0.8 : titleOpacity)
            .lineLimit(1)
          Spacer()
        }
        .padding()
        .padding(.top, 25)
      }
      Spacer()
    }
  }
}
