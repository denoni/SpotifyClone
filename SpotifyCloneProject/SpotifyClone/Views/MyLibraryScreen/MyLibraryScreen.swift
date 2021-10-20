//
//  MyLibraryScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/19/21.
//

import SwiftUI

struct MyLibraryScreen: View {
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

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
    VStack {
      ZStack {
        Color.spotifyMediumGray
          .shadow(color: .black, radius: 10)
        VStack {
          Spacer()
          HStack(spacing: 10) {
            Circle()
              .fill(Color.spotifyGreen)
              .overlay(Text("G").fontWeight(.bold).foregroundColor(.black))
              .scaledToFit()
            Text("My Library")
              .font(.avenir(.black, size: Constants.fontMedium))
            Spacer()
            Image("search-unselected")
              .resizeToFit()
              .padding(8)
              .opacity(Constants.opacityLow)
            Image(systemName: "plus") // TODO: Use the real icon from Spotify
              .resizeToFit()
              .padding(8)
              .opacity(Constants.opacityLow)
          }
          .frame(height: 35)
          .frame(maxWidth: .infinity)
          .padding(.horizontal, Constants.paddingStandard)
          Spacer()
        }
        .padding(.top, topSafeAreaSize)
      }
      .frame(height: 60 + topSafeAreaSize)
      .frame(maxWidth: .infinity)
      .ignoresSafeArea()


      ScrollView(showsIndicators: false) {
        MyLibraryItemsScrollView(medias: mediaTestArray)
      }
      .padding(.horizontal, Constants.paddingStandard)
      .padding(.bottom, Constants.paddingBottomSection)
      Spacer()
    }
  }
}

struct MyLibraryItemsScrollView: View {
  @State var medias: [SpotifyModel.MediaItem]
  var mockData: [(image: Image, title: String, subTitle: String)] = [(Image("liked-songs-cover"), "Liked Songs", "Playlist • 33 songs"),
                                                                   (Image("your-episodes-cover"), "Your Episodes", "Saved and downloaded episodes")]

  var body: some View {
    VStack {
      ForEach(mockData, id: \.title) { media in
        HStack(spacing: Constants.spacingSmall) {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(media.image.resizeToFit())
//            .overlay(RemoteImage(urlString: media.imageURL))
            .frame(width: 80, height: 80)
          VStack(alignment: .leading) {
            Text(media.title)
              .font(.avenir(.heavy, size: Constants.fontSmall))
              .lineLimit(1)
              .padding(.trailing, Constants.paddingLarge)
            HStack {
              Image(systemName: "pin.fill")
                .resizeToFit()
                .frame(height: 12)
                .foregroundColor(.spotifyGreen)
                .padding(.trailing, -3)
              Text(media.subTitle) // TODO: Show real data
                .font(.avenir(.medium, size: Constants.fontXSmall))
                .opacity(Constants.opacityHigh)
                .lineLimit(1)
            }
          }
          Spacer()
        }
        .frame(height: 80)
        .padding(.bottom, 10)
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
