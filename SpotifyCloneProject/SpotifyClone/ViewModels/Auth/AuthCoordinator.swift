//
//  AuthCoordinator.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import Foundation
import WebKit

class AuthCoordinator: NSObject, WKNavigationDelegate {
  @Published private var authViewModel: AuthViewModel

  init(_ viewModel: AuthViewModel) {
    self.authViewModel = viewModel
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    authViewModel.isLoading = false
  }

  func webView(_ webView: WKWebView,
               decidePolicyFor navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

    let newlyRequestedURL = navigationAction.request.url!.absoluteString

    // The response code from the Spotify auth API comes as a url.
    // If we see `?error=` in the response, we got an error instead of the code.
    guard newlyRequestedURL.contains("?error=") == false else {
      fatalError("Received an error from SpotifyAuth API, instead of the auth code.")
    }
    // When we see `?code=` in the response, we successfully got the code.
    if newlyRequestedURL.contains("?code=") == false {
      decisionHandler(.allow)
      return
    } else {
      authViewModel.isSpotifyResponseCode(url: newlyRequestedURL)
      decisionHandler(.cancel)
      webView.stopLoading()
      return
    }
  }
}
