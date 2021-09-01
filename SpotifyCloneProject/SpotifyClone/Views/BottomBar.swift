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
          BottomMediaPlayerBar()
        }
        BottomNavigationBar()
      }

    }
  }
}



private let grayLighter = Color(red: 0.196, green: 0.196, blue: 0.196)
private let grayDarker = Color(red: 0.153, green: 0.153, blue: 0.153)
private let grayHeavyLight = Color(red: 0.325, green: 0.325, blue: 0.325)



private struct BottomMediaPlayerBar: View {
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        Rectangle()
          .fill(grayHeavyLight)
          .frame(height: 3)
        HStack {
          HStack {
            Image("shape-of-you-cover")
              .resizable()
              .frame(width: 80)
              .aspectRatio(1/1, contentMode: .fit)
            VStack(alignment: .leading) {
              Text("Shape of You").font(.avenir(.heavy, size: 18))
                .frame(maxWidth: .infinity, alignment: .topLeading)
              Text("Ed Sheeran").font(.avenir(.medium, size: 16))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .opacity(0.7)
            }
          }
          Spacer()
          HStack(spacing: 30) {
            Image("devices")
              .resizable()
              .aspectRatio(1/1, contentMode: .fit)
              .padding(.vertical, 25)
            Image("play")
              .resizable()
              .aspectRatio(1/1, contentMode: .fit)
              .padding(.vertical, 30)
              .padding(.trailing, 25)
          }
        }
        .frame(height: 80)
        .background(Color(red: 0.157, green: 0.157, blue: 0.157))
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
          Spacer()
          VStack(alignment: .center, spacing: 5) {
            Spacer()
            Image("home-selected")
              .resizable()
              .aspectRatio(1/1, contentMode: .fit)
              .frame(width: 25)
            Text("Home").font(.avenir(.medium, size: 12))
          }.frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

          Spacer()

          VStack(alignment: .center, spacing: 5) {
            Spacer()
            Image("search-unselected")
              .resizable()
              .aspectRatio(1/1, contentMode: .fit)
              .frame(width: 25)
            Text("Search").font(.avenir(.medium, size: 12))
          }.frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

          Spacer()

          VStack(alignment: .center, spacing: 5) {
            Spacer()
            Image("library-unselected")
              .resizable()
              .aspectRatio(1/1, contentMode: .fit)
              .frame(width: 25)
            Text("Your Library").font(.avenir(.medium, size: 12))
          }.frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

          Spacer()
        }
        .frame(height: 60)
        .background(Color(red: 0.157, green: 0.157, blue: 0.157))
        Rectangle()
          .fill(Color(red: 0.157, green: 0.157, blue: 0.157))
          .ignoresSafeArea()
          .frame(height: 0)
      }
    }
  }
}
