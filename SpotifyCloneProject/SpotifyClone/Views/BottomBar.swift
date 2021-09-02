//
//  BottomBar.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/1/21.
//

import SwiftUI

struct BottomBar: View {
  var showMediaPlayer = false

  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      Group {
        if showMediaPlayer {
          BottomMediaPlayerBar(songName: "Shape of You",
                               artist: "Ed Sheeran",
                               cover: Image("shape-of-you-cover"))
        }
        BottomNavigationBar()
      }

    }
  }
}

private struct BottomMediaPlayerBar: View {
  var songName: String
  var artist: String
  var cover: Image

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        Rectangle()
          .fill(grayReallyLight)
          .frame(height: 3)
        HStack {
          HStack {
            cover
              .resizeToFit()
              .frame(width: 80)
            VStack(alignment: .leading) {
              Text(songName).font(.avenir(.heavy, size: 18))
                .frame(maxWidth: .infinity, alignment: .topLeading)
              Text(artist).font(.avenir(.medium, size: 16))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .opacity(0.7)
            }
          }
          Spacer()
          HStack(spacing: 30) {
            Image("devices")
              .resizeToFit()
              .padding(.vertical, 25)
            Image("play")
              .resizeToFit()
              .padding(.vertical, 30)
              .padding(.trailing, 25)
          }
        }
        .frame(height: 80)
        .background(Color.spotifyLightGray)
        Rectangle()
          .fill(Color.black)
          .frame(height: 0.5)
      }
    }
  }
}



private struct BottomNavigationBar: View {

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        HStack {
          BottomNavigationItem(itemName: "Home",
                               itemIcon: Image("home-selected"))
          BottomNavigationItem(itemName: "Search",
                               itemIcon: Image("search-unselected"))
          BottomNavigationItem(itemName: "Your Library",
                               itemIcon: Image("library-unselected"))
        }
        .frame(height: 60)
        .background(Color.spotifyLightGray)
        Rectangle()
          .fill(Color.spotifyLightGray)
          .ignoresSafeArea()
          .frame(height: 0)
      }
    }
  }

  private struct BottomNavigationItem: View {
    var itemName: String
    var itemIcon: Image

    var body: some View {
      Spacer()
      VStack(alignment: .center, spacing: 5) {
        Spacer()
        itemIcon
          .resizeToFit()
          .frame(width: 25)
        Text(itemName).font(.avenir(.medium, size: 12))
      }.frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      Spacer()
    }
  }

}

// MARK: - Constants

private let grayReallyLight = Color(red: 0.325, green: 0.325, blue: 0.325)

