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
  var medias: [SpotifyModel.MediaItem]
  var sectionTitle: String

  private var artist: SpotifyModel.MediaItem? { medias.isEmpty ? nil : medias[0] }

  private func getArtistSongs() -> [SpotifyModel.MediaItem] {
    var mediasWithArtist = medias
    mediasWithArtist.removeFirst()
    let mediasWithoutArtist = mediasWithArtist

    return mediasWithoutArtist
  }

  var body: some View {
    if !medias.isEmpty {
      VStack(spacing: Constants.spacingSmall) {
        ArtistImageAndTitle(artist: artist!)

        // Horizontal scroll view of artist's songs
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(alignment: .top, spacing: Constants.spacingLarge) {
            ForEach(getArtistSongs()) { media in
              BigSongItem(imageURL: media.imageURL, title: media.title, mediaType: media.mediaType)
                .onTapGesture {
                  homeVM.changeSubpageTo(.trackDetail, mediaDetailVM: mediaDetailVM, withData: media)
                }
                .onAppear { homeVM.homeCachedImageURLs.append(media.imageURL) }
                .onDisappear {
                  if homeVM.homeCachedImageURLs.count > 25 {
                    for _ in 0..<15 {
                      homeVM.deleteImageFromCache()
                    }
                  }
                }
            }
          }
          .padding(.horizontal, Constants.paddingSmall)
        }
        .padding(.leading, 10)
      }
    } else {
      EmptyView()
    }
  }

  private struct ArtistImageAndTitle: View {
    var artist: SpotifyModel.MediaItem

    var body: some View {
      HStack(alignment: .top, spacing: Constants.spacingSmall) {
        Circle()
          .overlay(RemoteImage(urlString: artist.imageURL))
          .aspectRatio(contentMode: .fit)
          .mask(Circle())
          .padding(3)
        VStack(alignment: .center) {
          Spacer()
          Text("FOR THE FANS OF").font(.avenir(.book, size: Constants.fontXSmall))
            .opacity(Constants.opacityStandard)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text(artist.authorName.first!)
            .spotifyTitle()
            .padding(.trailing, Constants.paddingLarge)
        }.frame(maxWidth: .infinity, alignment: .topLeading)
      }
      .frame(height: 60)
      .aspectRatio(contentMode: .fit)
      .padding(.leading, Constants.paddingStandard)
    }
  }
}
