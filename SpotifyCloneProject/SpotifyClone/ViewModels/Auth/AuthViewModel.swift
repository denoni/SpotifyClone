//
//  AuthViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import Foundation

class AuthViewModel: ObservableObject {
  @Published var isLoading = true
  @Published var exit = false
  @Published var authKeyIsAvailable = false

  static var apiAuth = APIAuthentication()
  var authKey: AuthKey?

  static var scope = "user-top-read"
  static var clientID = <YOUR_ID>
  static var clientSecret = <YOUR_SECRET>
  static var redirectURI = "https://www.github.com"
  static var url = apiAuth.getAuthURL(clientID: clientID, scope: scope, redirectURI: redirectURI)


  // TODO: -- TEMPORARY --
  @Published var trackItemIsAvailable = false
  var trackItem: TrackItem?
  // ---------------------


  func isSpotifyResponseCode(url: String) {
    DispatchQueue.main.async {
      let spotifyCode = url.replacingOccurrences(of: "\(AuthViewModel.redirectURI)/?code=", with: "")
      self.exit = true

      guard spotifyCode.count > 1 else {
        fatalError("Error getting spotify code.")
      }

      // TODO: -- TEMPORARY -- This call won't be done here.

      AuthViewModel.apiAuth.getAccessKey(code: spotifyCode,
                                         redirectURI: AuthViewModel.redirectURI,
                                         clientID: AuthViewModel.clientID,
                                         clientSecret: AuthViewModel.clientSecret) { authKey in

        self.authKey = authKey
        self.authKeyIsAvailable = true

        print("\n\n\nAUTH_KEY: \(self.authKey!)")

        self.getTopTracksFromArtist(accessToken: self.authKey!.accessToken)
      }

    }
  }

    // TODO: -- TEMPORARY -- This func won't be here.
    func getTopTracksFromArtist(accessToken: String) {
      DispatchQueue.main.async {
        let edSheeranID = "6eUKZXaKkcviH0Ku9w2n3V"

        APIFetchingData.getTopTracksFromArtist(accessToken: accessToken,
                                               country: "US",
                                               id: edSheeranID) { trackItem in
          self.trackItem = trackItem
          self.trackItemIsAvailable = true
        }
      }
    }
    // ---------------------------------------------

  }
