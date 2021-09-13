//
//  AuthViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import Foundation
import WebKit

class WebViewModel: ObservableObject {
  @Published var url: String
  @Published var isLoading: Bool = true
  @Published var exit: Bool = false
  @Published var spotifyCode = ""

  init (url: String) {
    self.url = url
  }

  func isSpotifyResponseCode(url: String) {

    let authScreen = AuthScreen()
    let spotifyCode = url.replacingOccurrences(of: "\(authScreen.redirectURI)/?code=", with: "")

    self.spotifyCode = spotifyCode
    exit = true

    print("\n\n CODE: \(spotifyCode) \n\n")
  }

}

class AuthCoordinator: NSObject, WKNavigationDelegate {
  private var viewModel: WebViewModel

  init(_ viewModel: WebViewModel) {
    self.viewModel = viewModel
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
              viewModel.isLoading = false
          }

  func webView(_ webView: WKWebView,
               decidePolicyFor navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

    let newlyRequestedURL = navigationAction.request.url!.absoluteString

    if newlyRequestedURL.contains("?code=") == false {
      decisionHandler(.allow)
      return
    } else {
      viewModel.isSpotifyResponseCode(url: newlyRequestedURL)
      decisionHandler(.cancel)
      webView.stopLoading()
      return
    }

  }
}
