//
//  RecommendedArtistScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct RecommendedArtistScrollView: View {
  @EnvironmentObject var homeVM: HomeViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @State var medias: [SpotifyModel.MediaItem]

  var artist: SpotifyModel.MediaItem { medias[0] }

  func getArtistSongs() -> [SpotifyModel.MediaItem] {
    var mediasWithArtist = medias
    mediasWithArtist.removeFirst()
    let mediasWithoutArtist = mediasWithArtist

    return mediasWithoutArtist
  }
  
  var sectionTitle: String  

  var body: some View {
    VStack(spacing: spacingSmallItems) {
      ArtistImageAndTitle(artist: artist)

      // Horizontal scroll view of artist's songs
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top,spacing: spacingBigItems) {
          ForEach(getArtistSongs()) { media in
            BigSongItem(imageURL: media.imageURL, title: media.title, mediaType: media.mediaType)
              .onTapGesture {
                homeVM.changeSubpageTo(.trackDetail, mediaDetailVM: mediaDetailVM, withData: media)
              }
          }
        }
        .padding(.horizontal, 25)
      }
    }
  }

  private struct ArtistImageAndTitle: View {
    var artist: SpotifyModel.MediaItem

    var body: some View {
      HStack(alignment: .top, spacing: spacingSmallItems) {
        Circle()
          .overlay(RemoteImage(urlString: artist.imageURL))
          .aspectRatio(contentMode: .fit)
          .mask(Circle())
          .padding(3)
        VStack(alignment: .center) {
          Spacer()
          Text("FOR THE FANS OF").font(.avenir(.book, size: 14))
            .opacity(0.7)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text(artist.authorName.first!)
            .spotifyTitle()
            .padding(.trailing, 40)
        }.frame(maxWidth: .infinity, alignment: .topLeading)
      }
      .frame(height: 60)
      .aspectRatio(contentMode: .fit)
      .padding(.leading, lateralPadding)
    }
  }
}



