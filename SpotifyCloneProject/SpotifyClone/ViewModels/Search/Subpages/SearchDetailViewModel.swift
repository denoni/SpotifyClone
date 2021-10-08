//
//  SearchDetailViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import Foundation
import Combine

class SearchDetailViewModel: ObservableObject {
  var api = APIFetchingDataSearchPage()
  @Published var accessToken: String?

  @Published private var userInputText: String = ""
  private var disposeBag = Set<AnyCancellable>()
  private var lastSearchedString: String = ""

  private var numberOfSearches = 0

  @Published var mediaResponses = [SpotifyModel.MediaItem]()

  /// `search` is used to make an API call to the search endpoint.
  /// It uses a delay of 0.5 seconds before searching, so it can
  /// search automatically after the user stops typing.
  func search(for userInput: String) {
    // We just check the numberOfSearches for precaution,
    // however the real api calls limit is pretty high.
    // So you can disable it if you want to, but there's
    // a risk of getting temporarily blocked.
    if numberOfSearches < 20 {
      userInputText = userInput
      $userInputText
        .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
        .sink {
          // If the userInputText is empty, we don't search
          if $0.isEmpty == false {
            // If we don't use this check, in case the user types,
            // lets say, 5 letters without stopping, it would
            // make 5 repeated API calls with the same search.
            if $0 != self.lastSearchedString {
              print("\n====== Searching for '\($0)' ======")
              print(">>> Song titles:")
              // TODO: Format the userInputText before searching
              self.api.search(for: $0, accessToken: self.accessToken!) { mediaItems in
                self.mediaResponses = mediaItems
                print("====== Finished ====== \n")
              }
              self.numberOfSearches += 1
            }
            self.lastSearchedString = $0
          }
        }
        .store(in: &disposeBag)
    } else { print("\nREACHED SEARCH LIMIT(You can disable this in `SearchDetailViewModel`)\n") }
  }

}
