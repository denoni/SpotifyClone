//
//  ActiveSearchViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import SwiftUI
import Combine
// need to import SwiftUI because of the CGFloat(currentScrollPosition)

class ActiveSearchViewModel: ObservableObject & FilterableViewModelProtocol {
  private var api = ActiveSearchPageAPICalls()
  var accessToken: String?
  @Published private var userInputText: String = ""
  private var lastSearchedString: String = ""
  private var numberOfSearches = 0
  @Published var mediaResponses = [SpotifyModel.MediaItem]()
  // Filter options that the user can tap to show only shows, playlists, etc...
  @Published var selectedMediaTypeFilter: SpotifyModel.MediaTypes?
  @Published var currentScrollPosition: CGFloat = 0
  private var disposeBag = Set<AnyCancellable>()

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
        .sink { [weak self] in
            // If we don't use this check, in case the user types,
            // lets say, 5 letters without stopping, it would
            // make 5 repeated API calls with the same search.
            if $0 != self?.lastSearchedString {
              let formattedSearchInput = self?.getFormattedString(for: $0)
              if formattedSearchInput != "" {
                self?.api.search(for: formattedSearchInput!,
                                 accessToken: (self?.accessToken!)!) { [weak self] mediaItems in
                  // Shuffled so the the responses are not separated by types
                  // (which is the way that Spotify's API originally responds).
                  self?.mediaResponses = mediaItems.shuffled()
                }
                self?.numberOfSearches += 1
                self?.lastSearchedString = $0
              }
            }
        }
        .store(in: &disposeBag)
    } else { print("\nREACHED SEARCH LIMIT(You can disable this in `SearchDetailViewModel`)\n") }
  }

  func getFormattedString(for string: String) -> String {
    return string
      .folding(options: .diacriticInsensitive, locale: .current)
      .trimmingCharacters(in: .whitespaces) // removes only the leading and trailing whitespaces
      .replacingOccurrences(of: " ", with: "+") // take the rest of the whitespaces and replace with "+"
      .lowercased()
  }
}
