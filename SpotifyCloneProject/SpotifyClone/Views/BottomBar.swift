//
//  BottomBar.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/1/21.
//

import SwiftUI

struct BottomBar: View {
  @StateObject var mainVM: MainViewModel
  var showMediaPlayer = false

  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      Group {
        if showMediaPlayer {
          BottomMediaPlayerBar(songName: "Nothing But The Beat",
                               artist: "Ed Sheeran",
                               cover: Image("nothing-but-the-beat-cover"))
        }
        BottomNavigationBar(mainVM: mainVM)
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
              Text(songName).font(.avenir(.medium, size: mediaTitleSize))
                .frame(maxWidth: .infinity, alignment: .topLeading)
              Text(artist).font(.avenir(.medium, size: mediaAuthorSize))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .opacity(0.6)
            }
            .padding(.vertical, 10)
          }
          Spacer()
          HStack(spacing: 30) {
            Image("devices")
              .resizeToFit()
              .padding(.vertical, 16)
              .opacity(0.7)
            Image("play")
              .resizeToFit()
              .padding(.vertical, 18)
              .padding(.trailing, 25)
          }
        }
        .frame(height: bottomMediaPlayerBarSize)
        .background(Color.spotifyLightGray)
        Rectangle()
          .fill(Color.spotifyDarkGray)
          .frame(height: 0.3)
      }
    }
  }
}


private struct BottomNavigationBar: View {
  @StateObject var mainVM: MainViewModel

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        HStack {
          BottomNavigationItem(mainVM: mainVM,
                               assignedPage: .home,
                               itemName: "Home",
                               iconWhenUnselected: Image("home-unselected"),
                               iconWhenSelected: Image("home-selected"))
          BottomNavigationItem(mainVM: mainVM,
                               assignedPage: .search,
                               itemName: "Search",
                               iconWhenUnselected: Image("search-unselected"),
                               iconWhenSelected: Image("search-selected"))
          BottomNavigationItem(mainVM: mainVM,
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

  private struct BottomNavigationItem: View {
    @StateObject var mainVM: MainViewModel
    var assignedPage: Page

    var itemName: String
    var iconWhenUnselected: Image
    var iconWhenSelected: Image

    var thisPageIsTheCurrentPage: Bool {
      mainVM.currentPage == assignedPage
    }

    var body: some View {
      VStack(alignment: .center, spacing: 5) {
        Spacer()
        buildIcon()
        Text(itemName).font(.avenir(.medium, size: bottomBarFontSize))
      }.frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      .onTapGesture { mainVM.currentPage = assignedPage}
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

// TODO: Move those constants out of here
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
private let bottomMediaPlayerBarSize: CGFloat = 60
private let coverImageSize: CGFloat = bottomMediaPlayerBarSize
private let mediaTitleSize: CGFloat = 16
private let mediaAuthorSize: CGFloat = 14



