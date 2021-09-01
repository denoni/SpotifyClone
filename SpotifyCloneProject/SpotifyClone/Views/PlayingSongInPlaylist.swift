//
//  PlayingSongInPlaylist.swift
//  SpotifyClone
//
//  Created by Gabriel on 8/30/21.
//

import SwiftUI

// TODO: Make frame min and max size so the layout
// stays right with differet screen sizes

struct PlayingSongInPlaylist: View {
  @State var time: Double = 0

  var body: some View {
    GradientBackGround(color: Color(red: 0.694,
                                    green: 0.569,
                                    blue: 0.439))
    VStack {
      TopBar(playlistName: "Your Mix")
      AlbumCover(albumCover: Image("album-cover-2"))
      CurrentPlayingInfoBar(songName: "Sweetener",
                            artistName: "Ariana Grande",
                            isLike: true)
      SpotifySlider()
      PlayerControllerBar()
      BottomSmallBar()
  }.padding(25)
  }
}

struct GradientBackGround: View {
  var color: Color

  var body: some View {
    LinearGradient(gradient: Gradient(colors: [color.opacity(0.8), color.opacity(0.0)]),
                   startPoint: .top, endPoint: .bottom).ignoresSafeArea()
  }
}

struct TopBar: View {
  var playlistName: String

  var body: some View {
    HStack {
      Group{
        Image("down-arrow")
          .resizable()
          .aspectRatio(1/1, contentMode: .fit)
          .padding(3)
        Spacer()
        Text(playlistName)
          .font(.avenir(.heavy, size: 16))
        Spacer()
        Image("three-dots")
          .resizable()
          .aspectRatio(1/1, contentMode: .fit)
          .padding(3)
      }
      .frame(height: 30,
             alignment: .center)
    }
  }
}

struct AlbumCover: View {
  var albumCover: Image

  var body: some View {
    Rectangle().fill(Color.white)
      .aspectRatio(1/1, contentMode: .fill)
      .overlay(albumCover
                .resizable()
                .aspectRatio(1/1,contentMode: .fill))
      .padding(.vertical, 50)
  }
}

struct BottomSmallBar: View {
  var body: some View {
    HStack {
      Image("devices")
        .resizable()
        .aspectRatio(1/1, contentMode: .fit)
        .padding(3)
      Spacer()
      Image("playlist")
        .resizable()
        .aspectRatio(1/1, contentMode: .fit)
        .padding(3)
    }.frame(height: 32,
            alignment: .center)
  }
}

struct PlayerControllerBar: View {
  var body: some View {
    HStack() {
      Image("play-mix")
        .resizable()
        .aspectRatio(1/1, contentMode: .fit)
        .padding(.vertical, 23)
      Spacer()
      Image("previous")
        .resizable()
        .aspectRatio(1/1, contentMode: .fit)
        .padding(.vertical, 22)
      Spacer()
      Image("circle-play")
        .resizable()
        .aspectRatio(contentMode: .fit)
      Spacer()
      Image("next")
        .resizable()
        .aspectRatio(1/1, contentMode: .fit)
        .padding(.vertical, 22)
      Spacer()
      Image("play-repeat")
        .resizable()
        .aspectRatio(1/1, contentMode: .fit)
        .padding(.vertical, 23)
    }.padding(5)
    .frame(height: 80,
           alignment: .center)
  }
}

struct CurrentPlayingInfoBar: View {
  var songName: String
  var artistName: String
  var isLike: Bool

  var body: some View {
    Group {
      HStack {
        VStack(alignment: .leading,
               spacing: 5) {
          Text(songName)
            .font(.avenir(.black, size: 28))
            .foregroundColor(.white)
          Text(artistName)
            .font(.avenir(.medium, size: 18))
            .foregroundColor(.white)
            .tracking(0.5)
        }.frame(
          maxWidth: .infinity,
          alignment: .topLeading
        )
        Image(isLike ? "heart-filled" : "heart-stroked")
          .resizable()
          .aspectRatio(1/1, contentMode: .fit)
          .padding(3)
          .frame(height: 30)
      }
    }.frame(height: 80)
  }
}

// TODO: Make this a real functional slider
struct SpotifySlider: View {
  var body: some View {
    VStack(spacing: 2) {
      ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: 5)
          .fill(Color.white)
          .frame(height: 4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          .opacity(0.25)
        Circle()
          .scaledToFit()
      }
      .frame(height: 20)
      HStack {
        Text("0:00")
          .font(.avenir(.medium, size: 13))
          .foregroundColor(.white)
        Spacer()
        Text("-3:48")
          .font(.avenir(.medium, size: 13))
          .foregroundColor(.white)
      }.padding(.horizontal, 3)
    }
  }
}
