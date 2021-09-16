//
//  RecommendedArtistScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

//struct RecommendedArtistScrollView: View {
//  @ObservedObject private(set) var homeViewModel: HomeViewModel
//
//  let sectionTitle: String
//  let newRecommendedArtist: RecommendedArtist
//
//  init(homeViewModel: HomeViewModel) {
//    self.homeViewModel = homeViewModel
//    sectionTitle = "For The Fans Of David Guetta"
//    newRecommendedArtist = RecommendedArtist.createNewRecommendedArtist(forItems: homeViewModel.getItems(fromSection: sectionTitle))
//  }
//  
//  var body: some View {
//    VStack(spacing: spacingSmallItems) {
//      HStack(alignment: .top, spacing: spacingSmallItems) {
//        Circle()
//          .overlay(newRecommendedArtist.image.resizeToFit())
//          .aspectRatio(contentMode: .fit)
//          .mask(Circle())
//          .padding(3)
//        VStack(alignment: .center) {
//          Spacer()
//          Text("FOR THE FANS OF").font(.avenir(.book, size: 14))
//            .opacity(0.7)
//            .frame(maxWidth: .infinity, alignment: .leading)
//          Text(newRecommendedArtist.name)
//            .spotifyTitle()
//        }.frame(maxWidth: .infinity, alignment: .topLeading)
//      }
//      .frame(height: 60)
//      .aspectRatio(contentMode: .fit)
//      .padding(.leading, lateralPadding)
//      ScrollView(.horizontal, showsIndicators: false) {
//        HStack(alignment: .top,spacing: spacingBigItems) {
//          Spacer(minLength: 5)
//          ForEach(newRecommendedArtist.items) { media in
//            BigSongItem(coverImage: media.content.coverImage,
//                        title: media.content.title,
//                        artist: "",
//                        isPodcast: media.content.isPodcast)
//          }
//        }
//      }
//    }
//  }
//
//  struct RecommendedArtist {
//    var name: String
//    var image: Image
//    var items: [SpotifyModel<SpotifyMediaContent>.SpotifyMedia]
//
//    static func createNewRecommendedArtist(forItems items: [SpotifyModel<SpotifyMediaContent>.SpotifyMedia]) -> RecommendedArtist {
//
//        var items = items
//        var contentFromItems = [SpotifyMediaContent]()
//        for index in items.indices {
//          contentFromItems.append(items[index].content)
//        }
//
//        // First Item == (recommendedArtistName, recommendedArtistImage)
//        let firstItem = contentFromItems.removeFirst()
//        items.removeFirst()
//
//        let artistName = firstItem.title
//        let artistImage = firstItem.coverImage
//
//
//      return RecommendedArtist(name: artistName, image: artistImage, items: items)
//    }
//  }
//
//}



