//
//  MyLibraryScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/19/21.
//

import SwiftUI

struct MyLibraryScreen: View {



  static let mediaForTest = SpotifyModel.MediaItem(title: "Don't Stop Me Now",
                                                   previewURL: "",
                                                   imageURL: "https://i.scdn.co/image/ab67616d0000b273008b06ec71019afd70153889",
                                                   authorName: ["Queen"],
                                                   author: nil,
                                                   mediaType: .track,
                                                   id: UUID().uuidString,
                                                   details: SpotifyModel.DetailTypes
                                                    .tracks(trackDetails: SpotifyModel.TrackDetails(popularity: 0,
                                                                                                    explicit: false,
                                                                                                    description: nil,
                                                                                                    durationInMs: 0,
                                                                                                    id: "abc",
                                                                                                    album: nil)))

  let mediaTestArray = Array(repeating: mediaForTest, count: 5)

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack {
        Text("My Library")
          .spotifyTitle()
        MyLibraryItemsScrollView(medias: mediaTestArray)
      }
      .padding(Constants.paddingStandard)
    }
  }
}

struct MyLibraryItemsScrollView: View {
  @State var medias: [SpotifyModel.MediaItem]

  var body: some View {
    VStack {
      ForEach(medias) { media in
        HStack(spacing: Constants.spacingSmall) {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(RemoteImage(urlString: media.imageURL))
            .frame(width: 80, height: 80)
          VStack(alignment: .leading) {
            Text(media.title)
              .font(.avenir(.medium, size: Constants.fontSmall))
              .lineLimit(1)
              .padding(.trailing, Constants.paddingLarge)
            Text("Single • 2020") // TODO: Show real data
              .font(.avenir(.medium, size: Constants.fontXSmall))
              .opacity(Constants.opacityHigh)
              .lineLimit(1)
          }
          Spacer()
        }
        .frame(height: 80)
        .padding(.top, 10)
        .onTapGesture {
          //TODO: Add on tap
        }
      }
    }
  }
}

struct MyLibraryScreen_Previews: PreviewProvider {
  static var previews: some View {
    MyLibraryScreen()
  }
}
