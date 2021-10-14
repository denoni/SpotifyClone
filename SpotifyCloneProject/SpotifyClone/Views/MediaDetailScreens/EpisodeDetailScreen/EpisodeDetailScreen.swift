//
//  EpisodeDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/14/21.
//

import SwiftUI

struct EpisodeDetailScreen: View {
  var mediaDetailVM: MediaDetailViewModel
  @State var scrollViewPosition = CGFloat.zero

  init(detailScreenOrigin: MediaDetailViewModel.DetailScreenOrigin, mediaDetailVM: MediaDetailViewModel) {
    self.mediaDetailVM = mediaDetailVM
    self.mediaDetailVM.detailScreenOrigin = detailScreenOrigin
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkGray
        ReadableScrollView(currentPosition: $scrollViewPosition) {
          VStack {
            TopGradient(height: geometry.size.height / 1.8)
            EpisodeDetailContent(scrollViewPosition: $scrollViewPosition)
              .padding(.top, -geometry.size.height / 1.8)
              .padding(.bottom, 180)
          }
        }
        TopBarWithTitle(scrollViewPosition: $scrollViewPosition,
                        title: mediaDetailVM.mainItem!.title,
                        backButtonShouldReturnTo: mediaDetailVM.detailScreenOrigin!)
      }.ignoresSafeArea()
    }
  }

}



// MARK: - Detail Content

struct EpisodeDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Binding var scrollViewPosition: CGFloat
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  var scale: CGFloat {
    let myScale = scrollViewPosition / UIScreen.main.bounds.height * 2
    return myScale > 0.8 ? 0.8 : myScale
  }

  var details: SpotifyModel.EpisodeDetails { SpotifyModel.getEpisodeDetails(for: mediaDetailVM.mainItem!) }

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.spacingMedium) {

      HStack(alignment: .top) {
        Text(mediaDetailVM.mainItem!.title)
          .font(.avenir(.black, size: Constants.fontXLarge))
          .lineLimit(4)
        Spacer()
      }
      .padding(.top, topSafeAreaSize)
      .padding(.top, Constants.paddingLarge)
      // Animate the opacity and size based on `scale`
      // (originated from the current position of the scroll view)
      .opacity(1 - Double(scale * 2 > 0.8 ? 0.8 : scale * 2))
      .frame(maxWidth: .infinity)

      AlbumAuthor()

      AuthorItem(name: "Author Name", // TODO: Add real name
                 id: "aaa", // TODO: Add real id
                 imageURL: mediaDetailVM.mainItem!.imageURL,
                 isPodcast: true)

      Text("Yesterday • Played") // TODO: Add real data
        .opacity(Constants.opacityStandard)
        .font(.avenir(.medium, size: Constants.fontXSmall))


      HStack {
        VStack(alignment: .leading) {

          HStack(spacing: Constants.paddingStandard) {
            Group {
              Image("plus-circle")
                .resizeToFit()
              Image("download-circle")
                .resizeToFit()
              Image("three-dots")
                .resizeToFit()
                .padding(.vertical, 3)
                .opacity(Constants.opacityStandard)
            }
            Spacer()
          }
          .frame(height: 25, alignment: .leading)

        }
        BigPlayButton()
      }.frame(height: 65)

      MediaDescription(description: details.description ?? "", lineLimit: 5)

      Text("20 Jul • 53min") // TODO: Add real data
        .opacity(Constants.opacityStandard)
        .font(.avenir(.medium, size: Constants.fontXSmall))

      Rectangle()
        .fill(Color.spotifyDarkGray)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        .overlay(RemoteImage(urlString: mediaDetailVM.mainItem!.imageURL))
        .padding(.vertical, Constants.paddingSmall)
        .padding(.horizontal, -Constants.paddingStandard)

      Text("20 Jul • 53min") // TODO: Add real data
        .opacity(Constants.opacityStandard)
        .font(.avenir(.medium, size: Constants.fontXSmall))
      //      if Utility.didEverySectionLoaded(in: .showDetail, mediaDetailVM: mediaDetailVM) {
      //        ShowEpisodesScrollView()
      //      } else {
      //        HStack {
      //          ProgressView()
      //            .withSpotifyStyle(useDiscreetColors: true)
      //            .onAppear {
      //              MediaDetailViewModel.UserInfoAPICalls.checksIfUserFollows(.show, mediaVM: mediaDetailVM)
      //              MediaDetailViewModel.ShowsAPICalls.getEpisodesFromShows(mediaVM: mediaDetailVM, loadMoreEnabled: true)
      //            }
      //        }
      //      }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(Constants.paddingStandard)
  }
}



// MARK: - Preview

struct EpisodeDetailScreen_Previews: PreviewProvider {
  static var mainVM = MainViewModel()

  static var previews: some View {
    ZStack {
      // `detailScreenOrigin` doesn't matter on preview.
      EpisodeDetailScreen(detailScreenOrigin: .home(homeVM: HomeViewModel(mainViewModel: mainVM)), mediaDetailVM: MediaDetailViewModel(mainVM: mainVM))
      VStack {
        Spacer()
        BottomBar(mainVM: mainVM,
                  showMediaPlayer: true)
      }
    }
  }
}
