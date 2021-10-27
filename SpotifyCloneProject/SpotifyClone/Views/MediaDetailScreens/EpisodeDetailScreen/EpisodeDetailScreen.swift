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
    .onDisappear {
      mediaDetailVM.cleanSectionFor(sectionMediaType: .episode)
    }
  }

}

// MARK: - Detail Content

private struct EpisodeDetailContent: View {
  @EnvironmentObject var mediaDetailVM: MediaDetailViewModel
  @Binding var scrollViewPosition: CGFloat
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  private var scale: CGFloat {
    let myScale = scrollViewPosition / UIScreen.main.bounds.height * 2
    return myScale > 0.8 ? 0.8 : myScale
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.spacingMedium) {

      HStack(alignment: .top) {
        Text(mediaDetailVM.mainItem!.title)
          .font(.avenir(.black, size: Constants.fontXLarge))
          .lineLimit(4)
          .fixedSize(horizontal: false, vertical: true)
        Spacer()
      }
      .padding(.top, topSafeAreaSize)
      .padding(.top, Constants.paddingLarge)
      // Animate the opacity and size based on `scale`
      // (originated from the current position of the scroll view)
      .opacity(1 - Double(scale * 2 > 0.8 ? 0.8 : scale * 2))
      .frame(maxWidth: .infinity)

      if Utility.didEverySectionLoaded(in: .episodeDetail, mediaDetailVM: mediaDetailVM) {

        Group {
          let episode = mediaDetailVM.mediaCollection[.episodes(.episodeDetails)]!.first!
          let episodeDetails = SpotifyModel.getEpisodeDetails(for: episode)

          let releaseDate = Utility.getSpelledOutDate(from: episodeDetails.releaseDate)
          let duration = Utility.formatTimeToHourMinSec(for: .milliseconds(episodeDetails.durationInMs),
                                                        spelledOut: true)

          AuthorItem(name: episode.authorName.first!,
                     id: episode.id,
                     imageURL: episode.author!.first!.images!.first!.url,
                     isPodcast: true)

          Text("\(releaseDate) • \(duration)")
            .opacity(Constants.opacityStandard)
            .font(.avenir(.medium, size: Constants.fontXSmall))

          HStack {
            VStack(alignment: .leading) {

              HStack(spacing: Constants.paddingStandard) {
                Group {
                  SaveButton(mediaDetailVM: mediaDetailVM,
                             itemID: episode.id,
                             itemType: .episode)
                  Image("download-circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                  Image("three-dots")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .opacity(Constants.opacityStandard)
                }
                Spacer()
              }
              .frame(height: 25, alignment: .leading)

            }
            BigPlayButton()
          }.frame(height: 65)

          MediaDescription(description: episodeDetails.description ?? "", lineLimit: 5)

          Rectangle()
            .fill(Color.spotifyDarkGray)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            .overlay(RemoteImage(urlString: mediaDetailVM.mainItem!.imageURL))
            .padding(.vertical, Constants.paddingSmall)
            .padding(.horizontal, -Constants.paddingStandard)

          Text("\(releaseDate) • \(duration)")
            .opacity(Constants.opacityStandard)
            .font(.avenir(.medium, size: Constants.fontXSmall))
        }

      } else {

        HStack {
          Spacer()
          ProgressView()
            .withSpotifyStyle(useDiscreetColors: true)
            .onAppear {
              mediaDetailVM.getEpisodesScreenData()
            }
          Spacer()
        }

      }

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
      EpisodeDetailScreen(detailScreenOrigin: .home(homeVM: HomeViewModel(mainViewModel: mainVM)),
                          mediaDetailVM: MediaDetailViewModel(mainVM: mainVM))
      VStack {
        Spacer()
        BottomBar(mainVM: mainVM,
                  showMediaPlayer: true)
      }
    }
  }
}
