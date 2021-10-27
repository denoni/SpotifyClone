//
//  AuthSheetView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import SwiftUI
import WebKit

struct AuthSheetView: View {
  @ObservedObject var authViewModel: AuthViewModel
  @Binding var isShowingSheetView: Bool

  var body: some View {
      if !authViewModel.finishedAuthentication {
        LoadingView(isLoading: $authViewModel.isLoading) {
          WebView(authViewModel: authViewModel)
            .opacity(authViewModel.isLoading ? 0 : 1)
        }
      } else {
        ProgressView()
          .withSpotifyStyle()
          .onAppear {
            isShowingSheetView = false
          }
      }
  }

}

struct WebView: UIViewRepresentable {
  // When the user opens the keyboard inside WebView,
  // a lot of errors will appear on terminal.
  // From what I've searched, the errors are
  // originated by a bug and won't affect the app.
  @ObservedObject var authViewModel: AuthViewModel
  let webView = WKWebView()

  func makeCoordinator() -> AuthCoordinator {
    AuthCoordinator(authViewModel)
  }

  func updateUIView(_ uiView: UIView,
                    context: UIViewRepresentableContext<WebView>) {}

  func makeUIView(context: Context) -> UIView {
    webView.navigationDelegate = context.coordinator

    if let url = URL(string: AuthViewModel.url) {
      webView.load(URLRequest(url: url))
    }

    return webView
  }
}
