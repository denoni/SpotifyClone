//
//  AlbumAuthor.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct AlbumAuthor: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  var authors: [SpotifyModel.MediaItem] { mediaDetailVM.returnBasicArtistsInfo() }

  var authorNames: String {
    var authorsToReturn = ""
    for authorIndex in authors.indices {
      authorsToReturn.append("\(authors[authorIndex].title), ")
    }
    // Remove the ", " from the last artist name.
    authorsToReturn.removeLast()
    authorsToReturn.removeLast()
    return authorsToReturn
  }

  var body: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], alignment: .leading) {
      ForEach(authors, id: \.id) { author in
        AuthorItem(name: author.title, id: author.id, imageURL: author.imageURL)
          .onTapGesture {
            switch mediaDetailVM.detailScreenOrigin {
            case .home(let homeVM):
              homeVM.changeSubpageTo(.artistDetail, mediaDetailVM: mediaDetailVM, withData: author)
            case .search(let searchVM):
              searchVM.goToPreviousPage()
            default:
              fatalError("Missing detail screen origin.")
            }
          }
      }
    }.frame(maxWidth: .infinity)
  }

  struct AuthorItem: View {
    var name: String
    var id: String
    var imageURL: String

    var body: some View {
      HStack {
        Circle()
          .foregroundColor(.black)
          .overlay(RemoteImage(urlString: imageURL).mask(Circle()))
          .frame(width: 25, height: 25)
        Text(name)
          .font(.avenir(.heavy, size: 16))
          .lineLimit(2)
          .frame(width: .none)
      }
    }
  }
}
