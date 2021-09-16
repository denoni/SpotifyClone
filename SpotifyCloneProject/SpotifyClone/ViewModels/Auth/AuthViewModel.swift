//
//  AuthViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import Foundation

class AuthViewModel: ObservableObject {
  @Published var mainViewModel: MainViewModel
  @Published var isLoading = true
  @Published var finishedAuthentication = false
  @Published var authKeyIsAvailable = false

  init(mainViewModel: MainViewModel) {
    self.mainViewModel = mainViewModel
  }

  static var apiAuth = APIAuthentication()
  var authKey: AuthKey?

  // Put your API id and secret inside YourSensitiveData and add it to .gitignore
  // How do I do I generate new api keys? Check APIAuthentication.swift
  static var clientID = YourSensitiveData.clientID
  static var clientSecret = YourSensitiveData.clientSecret

  // To know more about what all those variables are, check APIAuthentication.swift
  static var scope = "\(AuthScope.userReadRecentlyPlayed.rawValue)+\(AuthScope.userTopRead.rawValue)"
  static var redirectURI = "https://www.github.com"
  static var url = apiAuth.getAuthURL(clientID: clientID, scope: scope, redirectURI: redirectURI)


  func isSpotifyResponseCode(url: String) {
    DispatchQueue.main.async {
      let spotifyCode = url.replacingOccurrences(of: "\(AuthViewModel.redirectURI)/?code=", with: "")
      guard spotifyCode.count > 1 else {
        fatalError("Error getting spotify code.")
      }

      AuthViewModel.apiAuth.getAccessKey(code: spotifyCode,
                                         redirectURI: AuthViewModel.redirectURI,
                                         clientID: AuthViewModel.clientID,
                                         clientSecret: AuthViewModel.clientSecret) { authKey in

        self.authKey = authKey
        self.authKeyIsAvailable = true

        print("\n\n\nAUTH_KEY: \(self.authKey!)")

        self.finishedAuthentication = true
        self.mainViewModel.finishAuthentication(authKey: self.authKey!)
      }
    }
  }
}
