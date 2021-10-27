//
//  AuthScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import SwiftUI

struct AuthScreen: View {
  @StateObject var authViewModel: AuthViewModel
  @State var isShowingAuthWebView = false

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.03303453139, green: 0.03028165377, blue: 0.03578740901, alpha: 1)), Color(#colorLiteral(red: 0.06192958647, green: 0.05548349203, blue: 0.06590141785, alpha: 1))]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
          .ignoresSafeArea()
        VStack(alignment: .leading) {
          Image("spotify-full-logo")
            .resizable()
            .scaledToFit()
            .frame(width: geometry.size.width / 3.5)
            .padding(.vertical, Constants.paddingLarge)
          Spacer()
          HStack {
            Text("Millions of songs.\nFree on Spotify.")
              .font(.avenir(.black, size: geometry.size.width / 12))
              .tracking(-1)
            Spacer()
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 20)
          .padding(.vertical, geometry.size.height / 15)

          VStack {
            RoundedButton(text: "SIGN UP FREE") {
              isShowingAuthWebView = true
            }
              .padding(.bottom, 10)

            RoundedButton(text: "CONTINUE WITH FACEBOOK",
                          isFilled: false,
                          isStroked: true,
                          icon: Image("facebook-small-logo")) {
              isShowingAuthWebView = true
              print("\n\n >>> CAUTION: Not sign in manually is still causing crashes in some cases. \n\n")
            }
              .padding(.bottom, 20)
            RoundedButton(text: "LOG IN",
                          isFilled: false,
                          isStroked: false) {
              isShowingAuthWebView = true
            }
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, Constants.paddingLarge)
        }
        .padding(.horizontal, Constants.paddingLarge)
      }
      .sheet(isPresented: $isShowingAuthWebView, content: {
        AuthSheetView(authViewModel: authViewModel,
                      isShowingSheetView: $isShowingAuthWebView)
      })
    }
  }

  fileprivate struct RoundedButton: View {
    var text: String
    var isFilled = true
    var isStroked = false
    var icon: Image?
    var action: () -> Void

    var body: some View {
      Button(action: action) {
        HStack {
          if icon != nil {
            icon!
              .resizable()
              .renderingMode(.template)
              .scaledToFit()
              .padding(.vertical, 10)
          }
          Text(text)
            .font(.avenir(.heavy, size: Constants.fontXSmall))
            .tracking(1.5)
        }
        .padding(.horizontal, Constants.paddingSmall)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
      }
      .background( isFilled ? Capsule().foregroundColor(.spotifyGreen) : Capsule().foregroundColor(.white.opacity(0)))
      .background( isStroked ? Capsule().strokeBorder(Color.white) : Capsule().strokeBorder(Color.white.opacity(0)))
    }
  }

}
