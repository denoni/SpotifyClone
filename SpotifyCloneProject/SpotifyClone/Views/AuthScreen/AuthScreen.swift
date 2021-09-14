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
      Button(action: { isShowingAuthWebView = true }, label: {
        Text("Authenticate with API")
          .bold()
          .foregroundColor(.white)
          .padding()
          .background(Capsule().fill(Color.spotifyGreen))
      })
    }
    .sheet(isPresented: $isShowingAuthWebView , content: {
      AuthSheetView(authViewModel: authViewModel,
                    isShowingSheetView: $isShowingAuthWebView)
    })

    // -----------------------------------------------------------------
    // TODO : -- TEMPORARY --
    VStack(alignment: .center, spacing: 50) {

      // Shows Track Item that was fetched from API
      Group {
        if authViewModel.trackItemIsAvailable {
          VStack(alignment: .center) {

            RemoteImage(url: authViewModel.trackItem!.imageURL)
              .aspectRatio(1/1, contentMode: .fill)
              .padding(20)

            Text(authViewModel.trackItem!.name)
              .bold()
              .font(.title2)

            Text(authViewModel.trackItem!.artist)
              .opacity(0.6)
          }
        }
      }


      // Shows Auth Key fetched from API
      VStack(alignment: .center) {
        Text(authViewModel.authKeyIsAvailable ? "Auth key:" : "Auth key not ready." )
          .foregroundColor(Color.spotifyGreen)
          .bold()
          .font(.title)
        Text(authViewModel.authKeyIsAvailable ? authViewModel.authKey!.accessToken : "")
          .font(.footnote)
          .multilineTextAlignment(.center)
      }
    }
    // -----------------------------------------------------------------
  }
}
