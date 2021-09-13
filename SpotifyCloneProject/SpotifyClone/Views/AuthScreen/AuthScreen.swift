//
//  AuthScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

// TODO: - TEMPORARY AUTH SCREEN - Create a legit auth screen
import SwiftUI

struct AuthScreen: View {
  @State var isShowingAuthWebView = false

  var scope = "streaming"
  var clientID = <YOUR ID>
  var redirectURI = "https://www.github.com"

  var apiAuth = APIAuthentication()

  var body: some View {
    NavigationView {
      Button(action: { isShowingAuthWebView = true }, label: {
        Text("Authenticate with API")
          .bold()
          .foregroundColor(.white)
          .padding()
          .background(Capsule().fill(Color.spotifyGreen))
      })

    }.sheet(isPresented: $isShowingAuthWebView, content: {
      AuthScreenWebView(url: apiAuth.getAuthURL(clientID: clientID,
                                                scope: scope,
                                                redirectURI: redirectURI))
    })
  }

}
