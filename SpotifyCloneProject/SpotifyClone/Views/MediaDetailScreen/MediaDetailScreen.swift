//
//  MediaDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/23/21.
//

// TODO: Extract the custom views
// TODO: Support all media types

import SwiftUI

struct MediaDetailScreen: View {
  var homeViewModel: HomeViewModel

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkerGray
        ScrollView(showsIndicators: false) {
          VStack {
            TopGradient(mediaDetailViewModel: homeViewModel.mediaDetailViewModel,
                        height: geometry.size.height / 1.8)
            DetailContent(homeViewModel: homeViewModel)
              .padding(.top, -geometry.size.height / 1.8)
              .padding(.bottom, 180)
          }
        }
        .disabledBouncing()

      }.ignoresSafeArea()
    }
  }
}



fileprivate struct DetailContent: View {
  var homeViewModel: HomeViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      ZStack {
        BackButton(homeViewModel: homeViewModel)
        BigMediaCover(mediaDetailViewModel: homeViewModel.mediaDetailViewModel)
      }
      .padding(.top, 25)

      MediaDescription(mediaDetailViewModel: homeViewModel.mediaDetailViewModel)
      PlaylistAuthor(mediaDetailViewModel: homeViewModel.mediaDetailViewModel)

      HStack {
        VStack(alignment: .leading) {
          MediaLikesAndDuration(mediaDetailViewModel: homeViewModel.mediaDetailViewModel)
          LikeAndThreeDotsIcons()
        }
        BigPlayButton()
      }.frame(height: 65)

      MediasScrollView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(25)
  }
}

struct TopGradient: View {
  @ObservedObject var mediaDetailViewModel: MediaDetailViewModel

  var height: CGFloat
  @State var color: Color

  init(mediaDetailViewModel: MediaDetailViewModel, height: CGFloat) {
    self.mediaDetailViewModel = mediaDetailViewModel
    self.height = height
    mediaDetailViewModel.imageColorModel = RemoteImageModel(urlString: mediaDetailViewModel.media!.imageURL)
    color = Color(mediaDetailViewModel.imageColorModel.image?.averageColor! ?? .clear)
  }

  var body: some View {
    Rectangle()
      .fill(LinearGradient(gradient: Gradient(colors: [color.opacity(0.8),
                                                       color.opacity(0.4),
                                                       color.opacity(0.0)]),
                           startPoint: .top,
                           endPoint: .bottom))
      .frame(height: height)
  }
}

fileprivate struct BackButton: View {
  var homeViewModel: HomeViewModel

  var body: some View {
    VStack {
      HStack {
        Image("down-arrow")
          .resizeToFit()
          .rotationEffect(Angle.degrees(90))
        Spacer()
      }
      .frame(height: 20)
      .onTapGesture {
        homeViewModel.goToNoneSubpage()
      }
      Spacer()
    }
  }
}

fileprivate struct BigMediaCover: View {
  @ObservedObject var mediaDetailViewModel: MediaDetailViewModel

  var body: some View {
    HStack {
      Spacer()
      Rectangle()
        .foregroundColor(.spotifyMediumGray)
        .overlay(RemoteImage(urlString: mediaDetailViewModel.media!.imageURL))
        .frame(width: 250, height: 250)
        .shadow(color: .spotifyDarkerGray.opacity(0.3), radius: 15)
      Spacer()
    }
    .padding(.bottom, 10)
  }
}

fileprivate struct MediaDescription: View {
  @ObservedObject var mediaDetailViewModel: MediaDetailViewModel

  var body: some View {
    // TODO: Description is only implemented in `rewindPlaylists`, implement in all home medias
    // (Will crash if you clicked in a media that is not a `rewindPlaylist`)
    Text(mediaDetailViewModel.media!.details.description)
      .opacity(0.9)
  }
}

fileprivate struct PlaylistAuthor: View {
  @ObservedObject var mediaDetailViewModel: MediaDetailViewModel

  var body: some View {
    HStack {
      Circle()
        .foregroundColor(.black)
        // TODO: Get image from api.
        .overlay(Image("spotify-small-logo")
                  .resizable()
                  .scaledToFit()
                  .colorMultiply(.spotifyGreen))
        .frame(width: 25, height: 25)
      Text(mediaDetailViewModel.media!.author)
        .font(.avenir(.heavy, size: 16))
      Spacer()
    }
  }
}

fileprivate struct MediaLikesAndDuration: View {
  @ObservedObject var mediaDetailViewModel: MediaDetailViewModel

  var body: some View {
    Text("\(mediaDetailViewModel.media!.details.tracks.numberOfSongs) songs • 1h 22m")
      .opacity(0.6)
  }
}

fileprivate struct LikeAndThreeDotsIcons: View {
  var body: some View {
    HStack(spacing: 30) {
      Image("heart-stroked")
        .resizable()
        .scaledToFit()
      Image("three-dots")
        .resizable()
        .scaledToFit()
      Spacer()
    }
    .frame(height: 25)
    .frame(maxWidth: .infinity)
  }
}

fileprivate struct BigPlayButton: View {
  var body: some View {
    Circle()
      .scaledToFit()
      .foregroundColor(.spotifyGreen)
      .overlay(Image("play").resizeToFit().padding(20).padding(.leading, 3))
  }
}

fileprivate struct MediasScrollView: View {
  let arr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
  var body: some View {
    LazyVStack {
      ForEach(arr, id: \.self) { _ in
        HStack(spacing: 12) {
          Rectangle()
            .foregroundColor(.spotifyMediumGray)
            .overlay(Image("come-as-you-are-cover")
                      .resizeToFit())
            .frame(width: 60, height: 60)
          VStack(alignment: .leading) {
            Text("Sweetener (Studio Mix)")
              .font(.avenir(.medium, size: 20))
            Text("Ariana Grande")
              .font(.avenir(.medium, size: 16))
              .opacity(0.7)
          }
          Spacer()
          Image("three-dots")
            .resizeToFit()
            .padding(.vertical, 16)
        }
        .frame(height: 60)
      }
    }
    .padding(.top, 15)
  }
}



struct MediaDetailScreen_Previews: PreviewProvider {
  static var mainViewModel = MainViewModel()

  static var previews: some View {
    ZStack {
      MediaDetailScreen(homeViewModel: HomeViewModel(mainViewModel: mainViewModel))
      VStack {
        Spacer()
        BottomBar(mainViewModel: mainViewModel, showMediaPlayer: true)
      }
    }
  }
}
