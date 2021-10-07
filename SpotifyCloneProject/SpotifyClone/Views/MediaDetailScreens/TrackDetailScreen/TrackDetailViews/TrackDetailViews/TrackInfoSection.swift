//
//  TrackInfoSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct TrackInfoSection: View {
  var songName: String
  var authors: [Artist]
  var isLiked: Bool
  var isExplicit: Bool
  var isSmallDisplay: Bool = false

  var body: some View {
    Group {
      HStack {
        VStack(alignment: .leading,
               spacing: 0) {
          MediaTitle(mediaTitle: songName, useSmallerFont: isSmallDisplay)
            .padding(.trailing, 25)
          HStack(spacing: 0) {
            ExplicitIcon(isExplicit: isExplicit)
              .padding(.trailing, isExplicit ? 5 : 0)
            // TODO: Open artist's profile onClick
            Text(getAuthorNames(from: authors))
              .font(.avenir(.medium, size: isSmallDisplay ? 16 : 18))
              .foregroundColor(.white)
              .tracking(0.5)
          }
          .opacity(0.7)
          .padding(.trailing, 25)
        }.frame(
          maxWidth: .infinity,
          alignment: .topLeading
        )
        Image(isLiked ? "heart-filled" : "heart-stroked")
          .resizeToFit()
          .padding(3)
          .frame(height: 30)
      }
    }
  }

  private func getAuthorNames(from authors: [Artist]) -> String {
    var authorsToReturn = ""
    for authorIndex in authors.indices {
      authorsToReturn.append("\(authors[authorIndex].name), ")
    }
    // Remove the ", " from the last artist name.
    authorsToReturn.removeLast()
    authorsToReturn.removeLast()
    return authorsToReturn
  }
}
