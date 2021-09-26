//
//  RecommendedArtistScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct RecommendedArtistScrollView: View {
  @StateObject var homeViewModel: HomeViewModel
  @State var medias: [SpotifyModel.MediaItem]
  // The first item of the array is the artist info

  func getArtistInfo() -> SpotifyModel.MediaItem {
    return medias[0]
  }

  func getArtistSongs() -> [SpotifyModel.MediaItem] {
    var mediasWithArtist = medias
    mediasWithArtist.removeFirst()
    let mediasWithoutArtist = mediasWithArtist

    return mediasWithoutArtist
  }
  
  var sectionTitle: String  

  var body: some View {
    VStack(spacing: spacingSmallItems) {
      HStack(alignment: .top, spacing: spacingSmallItems) {
        Circle()
          .overlay(RemoteImage(urlString: getArtistInfo().imageURL))
          .aspectRatio(contentMode: .fit)
          .mask(Circle())
          .padding(3)
        VStack(alignment: .center) {
          Spacer()
          Text("FOR THE FANS OF").font(.avenir(.book, size: 14))
            .opacity(0.7)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text(getArtistInfo().author)
            .spotifyTitle()
        }.frame(maxWidth: .infinity, alignment: .topLeading)
      }
      .frame(height: 60)
      .aspectRatio(contentMode: .fit)
      .padding(.leading, lateralPadding)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top,spacing: spacingBigItems) {
          ForEach(getArtistSongs()) { media in
            BigSongItem(imageURL: media.imageURL,
                        title: media.title)
              .onTapGesture {
                homeViewModel.changeSubpageTo(.stillToBeMade,
                                              mediaDetailViewModel: homeViewModel.mediaDetailViewModel,
                                              withData: media)
              }
          }
        }
        .padding(.horizontal, 25)
      }
    }
  }
}



