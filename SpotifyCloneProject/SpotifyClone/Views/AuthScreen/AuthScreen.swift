//
//  AuthScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

// TODO: - TEMPORARY AUTH SCREEN - Create a legit auth screen
import SwiftUI

struct AuthScreen: View {
  @StateObject var authViewModel: AuthViewModel
  @State var isShowingAuthWebView = false
  
  var body: some View {
    NavigationView {
      Button(action: { isShowingAuthWebView = true }, label: {
        Text("Authenticate with API")
          .bold()
          .foregroundColor(.white)
          .padding()
          .background(Capsule().fill(Color.spotifyGreen))
      })
    }
    .sheet(isPresented: $isShowingAuthWebView, content: {
      AuthSheetView(authViewModel: authViewModel,
                    isShowingSheetView: $isShowingAuthWebView)
    })
  }
}
