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
  @State var currentLoadedMediasURLs = [String]()

  let section: HomeViewModel.Section
  var showArtistName: Bool = false
  var sectionTitle = ""
  var medias: [SpotifyModel.MediaItem] {
    homeVM.mediaCollection[section]!
  }

  var detailType: HomeViewModel.HomeSubpage {
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
    VStack(spacing: Constants.spacingSmall) {
      Text(sectionTitle.isEmpty ? section.rawValue : sectionTitle)
        .spotifyTitle(withPadding: true)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top,spacing: Constants.spacingLarge) {
          ForEach(medias) { media in
            BigSongItem(imageURL: media.imageURL,
                        title: media.title,
                        artist: showArtistName ? media.authorName.joined(separator: ", ") : "",
                        mediaType: media.mediaType)
              .onAppear {
                if mediaDetailVM.shouldFetchMoreData(basedOn: media, inRelationTo: medias) {
                  homeVM.fetchDataFor(section, with: homeVM.mainVM.authKey!.accessToken)
                }
                currentLoadedMediasURLs.append(media.imageURL)
              }
              .onDisappear{
                if currentLoadedMediasURLs.count > 10 {
                  for index in 0..<5 {
                    homeVM.deleteImageFromCache(imageURL: currentLoadedMediasURLs[index])
                    currentLoadedMediasURLs.removeFirst()
                  }
                }
              }
              .onTapGesture {
                homeVM.changeSubpageTo(detailType,
                                       mediaDetailVM: mediaDetailVM,
                                       withData: media)
              }
            .buttonStyle(PlainButtonStyle())
          }
        }.padding(.horizontal, Constants.paddingStandard)
      }
    }
  }
}
