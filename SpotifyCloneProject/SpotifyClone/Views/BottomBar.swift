//
//  BottomBar.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/1/21.
//

import SwiftUI

struct BottomBar: View {
  @StateObject var mainViewModel: MainViewModel
  var showMediaPlayer = false

  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      if mainViewModel.currentPage != .auth {
        Group {
          if showMediaPlayer {
            BottomMediaPlayerBar(songName: "Shape of You",
                                 artist: "Ed Sheeran",
                                 cover: Image("shape-of-you-cover"))
          }
          BottomNavigationBar(mainViewModel: mainViewModel)
        }
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
              .frame(width: coverImageSize)
            VStack(alignment: .leading) {
              Text(songName).font(.avenir(.heavy, size: mediaTitleSize))
                .frame(maxWidth: .infinity, alignment: .topLeading)
              Text(artist).font(.avenir(.medium, size: mediaAuthorSize))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .opacity(0.6)
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
        .frame(height: bottomMediaPlayerBarSize)
        .background(Color.spotifyLightGray)
        Rectangle()
          .fill(Color.black)
          .frame(height: 0.5)
      }
    }
  }
}


private struct BottomNavigationBar: View {
  @StateObject var mainViewModel: MainViewModel

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        HStack {
          BottomNavigationItem(mainViewModel: mainViewModel,
                               assignedPage: .home,
                               itemName: "Home",
                               iconWhenUnselected: Image("home-unselected"),
                               iconWhenSelected: Image("home-selected"))
          BottomNavigationItem(mainViewModel: mainViewModel,
                               assignedPage: .search,
                               itemName: "Search",
                               iconWhenUnselected: Image("search-unselected"),
                               iconWhenSelected: Image("search-selected"))
          BottomNavigationItem(mainViewModel: mainViewModel,
                               assignedPage: .myLibrary,
                               itemName: "My Library",
                               iconWhenUnselected: Image("library-unselected"),
                               iconWhenSelected: Image("library-selected"))
        }
        .frame(height: bottomNavigationBarSize)
        .background(Color.spotifyLightGray)
        Rectangle()
          .fill(Color.spotifyLightGray)
          .ignoresSafeArea()
          .frame(height: 0)
      }
    }
  }

  // TODO: Call this struct in a clever way
  private struct BottomNavigationItem: View {
    @StateObject var mainViewModel: MainViewModel
    var assignedPage: Page

    var itemName: String
    var iconWhenUnselected: Image
    var iconWhenSelected: Image

    var thisPageIsTheCurrentPage: Bool {
      mainViewModel.currentPage == assignedPage
    }

    var body: some View {
      VStack(alignment: .center, spacing: 5) {
        Spacer()
        buildIcon()
        Text(itemName).font(.avenir(.medium, size: bottomBarFontSize))
      }.frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      .onTapGesture { mainViewModel.currentPage = assignedPage}
      .foregroundColor(thisPageIsTheCurrentPage ? selectedItemColor : unselectedItemColor)
    }

    func buildIcon() -> some View {
      var icon: Image

      if thisPageIsTheCurrentPage {
        icon = iconWhenSelected
      } else {
        icon = iconWhenUnselected
      }

      return icon.resizeToFit()
        .colorMultiply(thisPageIsTheCurrentPage ? selectedItemColor : unselectedItemColor)
        .frame(width: bottomBarIconSize)
    }
  }

}

// MARK: - Constants

private let grayReallyLight = Color(red: 0.325, green: 0.325, blue: 0.325)


// MARK: BottomNavigationItem Constants
private let selectedItemColor = Color.white
private let unselectedItemColor = selectedItemColor.opacity(0.5)
private let bottomBarIconSize: CGFloat = 25
private let bottomBarFontSize: CGFloat = 12

// MARK: BottomNavigationBar Constants
private let bottomNavigationBarSize: CGFloat = 60

// MARK: BottomMediaPlayerBar Constants
private let bottomMediaPlayerBarSize: CGFloat = 80
private let coverImageSize: CGFloat = bottomMediaPlayerBarSize
private let mediaTitleSize: CGFloat = 18
private let mediaAuthorSize: CGFloat = 16



