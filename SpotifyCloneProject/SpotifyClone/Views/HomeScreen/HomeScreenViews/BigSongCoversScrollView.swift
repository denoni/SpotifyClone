//
//  BigSongCoverScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/3/21.
//

import SwiftUI

struct BigSongCoversScrollView: View {
  @EnvironmentObject var homeVM: HomeViewModel
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel

  let section: HomeViewModel.Section
  var showArtistName: Bool = false
  var sectionTitle = ""
  private var medias: [SpotifyModel.MediaItem] {
    homeVM.mediaCollection[section]!
  }

  private var detailType: HomeViewModel.HomeSubpage? {
    guard medias.isEmpty == false else { return nil }

    switch medias.first!.mediaType {
    case .playlist:
      return HomeViewModel.HomeSubpage.playlistDetail
    case .track:
      return HomeViewModel.HomeSubpage.trackDetail
    case .album:
      return HomeViewModel.HomeSubpage.albumDetail
    case .show:
      return HomeViewModel.HomeSubpage.showDetail
    case .artist:
      return HomeViewModel.HomeSubpage.artistDetail
    case .episode:
      fatalError("Type not implemented yet.")
    }
  }

  var body: some View {
    if !medias.isEmpty {
      VStack(spacing: Constants.spacingSmall) {
        Text(sectionTitle.isEmpty ? section.rawValue : sectionTitle)
          .spotifyTitle(withPadding: true)
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(alignment: .top, spacing: Constants.spacingLarge) {
            ForEach(medias) { media in
              BigSongItem(imageURL: media.imageURL,
                          title: media.title,
                          artist: showArtistName ? media.authorName.joined(separator: ", ") : "",
                          mediaType: media.mediaType)
                .onAppear {
                  if mediaDetailVM.shouldFetchMoreData(basedOn: media, inRelationTo: medias) {
                    homeVM.fetchDataFor(section, with: homeVM.mainVM.authKey!.accessToken)
                  }

                  homeVM.homeCachedImageURLs.append(media.imageURL)
                }
                .onDisappear {
                  if homeVM.homeCachedImageURLs.count > 25 {
                    for _ in 0..<15 {
                      homeVM.deleteImageFromCache()
                    }
                  }
                }
                .onTapGesture {
                  homeVM.changeSubpageTo(detailType!,
                                         mediaDetailVM: mediaDetailVM,
                                         withData: media)
                }
              .buttonStyle(PlainButtonStyle())
            }
          }.padding(.horizontal, Constants.paddingStandard)
        }
      }
    } else {
      EmptyView()
    }
  }
}
