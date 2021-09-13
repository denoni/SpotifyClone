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
  @State var spotifyCode = ""

  var scope = "playlist-modify-private"
  var clientID = "28343fa78d8f458c8feb35e53398ecd9" //<YOUR_ID>
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

    }
    .sheet(isPresented: $isShowingAuthWebView, content: {
      AuthSheetView(webViewModel: WebViewModel(url: apiAuth.getAuthURL(clientID: clientID,
                                                                       scope: scope,
                                                                       redirectURI: redirectURI)),
                    showView: self.$isShowingAuthWebView,
                    spotifyCode: $spotifyCode)
    })
  }

}
