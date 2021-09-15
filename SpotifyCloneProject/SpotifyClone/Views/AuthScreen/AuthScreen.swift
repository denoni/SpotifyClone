//
//  AuthScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

// TODO: - TEMPORARY AUTH SCREEN - Create a legit auth screen
import SwiftUI

struct AuthScreen: View {
  @ObservedObject private(set) var authViewModel: AuthViewModel
  @State var isShowingAuthWebView = false

  var body: some View {
    NavigationView {
      VStack {
        VStack {
          Button(action: { isShowingAuthWebView = true }, label: {
            Text("Authenticate with API")
              .bold()
              .foregroundColor(.white)
              .padding()
              .background(Capsule().fill(Color.spotifyGreen))
          })
        }

        Spacer()
      }
    }
    .sheet(isPresented: $isShowingAuthWebView , content: {
      AuthSheetView(authViewModel: authViewModel,
                    isShowingSheetView: $isShowingAuthWebView)
    })
  }
}
