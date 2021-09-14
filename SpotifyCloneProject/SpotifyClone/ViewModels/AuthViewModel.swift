//
//  AuthViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import Foundation
import WebKit

class AuthViewModel: ObservableObject {
  @Published var isLoading = true
  @Published var exit = false
  @Published var authKeyIsAvailable = false

  static var apiAuth = APIAuthentication()

  static var scope = "playlist-modify-private"
  static var clientID = <YOUR_ID>
  static var clientSecret = <YOUR_SECRET>
  static var redirectURI = "https://www.github.com"
  static var url = apiAuth.getAuthURL(clientID: clientID, scope: scope, redirectURI: redirectURI)

  var authKey: AuthKey?

  func isSpotifyResponseCode(url: String) {
    DispatchQueue.main.async {
      let spotifyCode = url.replacingOccurrences(of: "\(AuthViewModel.redirectURI)/?code=", with: "")
      self.exit = true

      guard spotifyCode.count > 1 else {
        fatalError("Error getting spotify code.")
      }

      AuthViewModel.apiAuth.getAccessKey(code: spotifyCode,
                                         redirectURI: AuthViewModel.redirectURI,
                                         clientID: AuthViewModel.clientID,
                                         clientSecret: AuthViewModel.clientSecret) { authKey in
        self.authKeyIsAvailable = true
        self.authKey = authKey
      }
    }
  }

  func getAuthKey(_ authKey: AuthKey) -> (String, String, String) {

    let accessToken = authKey.accessToken
    let refreshToken = authKey.refreshToken
    let scope = authKey.scope

    return (accessToken, refreshToken, scope)
  }

}

class AuthCoordinator: NSObject, WKNavigationDelegate {
  private var authViewModel: AuthViewModel

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
