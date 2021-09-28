//
//  AlbumAuthor.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct AlbumAuthor: View {
  @State var authors: [Artist]

  var authorNames: String {
    var authorsToReturn = ""
    for authorIndex in authors.indices {
      authorsToReturn.append("\(authors[authorIndex].name), ")
    }
    // Remove the ", " from the last artist name.
    authorsToReturn.removeLast()
    authorsToReturn.removeLast()
    return authorsToReturn
  }

  var body: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .leading) {
      ForEach(authors, id: \.id) { author in
        AuthorItem(author: author)
      }
    }.frame(maxWidth: .infinity)
  }

  struct AuthorItem: View {
    var author: Artist

    var body: some View {
      HStack {
        Circle()
          .foregroundColor(.black)
          // TODO: Get image from api.
          .overlay(Image("spotify-small-logo")
                    .resizable()
                    .scaledToFit()
                    .colorMultiply(.spotifyGreen))
          .frame(width: 25, height: 25)
        Text(author.name)
          .font(.avenir(.heavy, size: 16))
      }
    }
  }
}
