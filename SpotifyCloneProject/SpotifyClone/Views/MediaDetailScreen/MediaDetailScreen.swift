//
//  MediaDetailScreen.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/23/21.
//

import SwiftUI

struct MediaDetailScreen: View {
  var homeViewModel: HomeViewModel

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.spotifyDarkerGray
        ScrollView {
          VStack {
            TopGradient(height: geometry.size.height / 1.8)
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



struct TopGradient: View {
  var height: CGFloat
  var color: Color = Color(#colorLiteral(red: 0.05098039216, green: 0.6078431373, blue: 0.7843137255, alpha: 1))

  var body: some View {
    Rectangle()
      .fill(LinearGradient(gradient: Gradient(colors: [color.opacity(0.6),
                                                       color.opacity(0.30),
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
        homeViewModel.changeSubpageTo(.none)
      }

      Spacer()
    }
  }
}

fileprivate struct BigMediaCover: View {
  var body: some View {
    HStack {
      Spacer()
      Rectangle()
        .foregroundColor(.spotifyMediumGray)
        .overlay(Image("come-as-you-are-cover").resizable())
        .frame(width: 250, height: 250)
        .shadow(color: .spotifyDarkerGray.opacity(0.3), radius: 15)
      Spacer()
    }
    .padding(.bottom, 10)
  }
}

fileprivate struct MediaDescription: View {
  var body: some View {
    Text("The most iconic songs of the year in just one playlist. Listen and remember the vibes.")
      .opacity(0.9)
  }
}

fileprivate struct PlaylistAuthor: View {
  var body: some View {
    HStack {
      Circle()
        .foregroundColor(.black)
        .overlay(Image("spotify-small-logo")
                  .resizable()
                  .scaledToFit()
                  .colorMultiply(.spotifyGreen))
        .frame(width: 25, height: 25)
      Text("Spotify")
        .font(.avenir(.heavy, size: 16))
      Spacer()
    }
  }
}

fileprivate struct MediaLikesAndDuration: View {
  var body: some View {
    Text("400,000 likes • 1h 22m")
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

fileprivate struct DetailContent: View {
  var homeViewModel: HomeViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      ZStack {
        BackButton(homeViewModel: homeViewModel)
        BigMediaCover()
      }
      .padding(.top, 25)

      MediaDescription()
      PlaylistAuthor()

      HStack {
        VStack(alignment: .leading) {
          MediaLikesAndDuration()
          LikeAndThreeDotsIcons()
        }
        BigPlayButton()
      }.frame(height: 65)

      let arr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]

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
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(25)
  }
}

struct MediaDetailScreen_Previews: PreviewProvider {
  static var previews: some View {
    MediaDetailScreen(homeViewModel: HomeViewModel(mainViewModel: MainViewModel()))
  }
}
