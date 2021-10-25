//
//  MyLibraryTopBar.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import SwiftUI

struct MyLibraryTopBar: View {
  @EnvironmentObject var myLibraryVM: MyLibraryViewModel
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  var body: some View {
    VStack(spacing: 0) {
      VStack {
        HStack(alignment: .center, spacing: 10) {
          MyLibraryProfileImageAndTitle()
          Spacer()
          Image("search-unselected")
            .resizeToFit()
            .padding(8)
            .opacity(Constants.opacityLow)
          Image(systemName: "plus") // TODO: Use the real icon from Spotify
            .resizeToFit()
            .padding(8)
            .opacity(Constants.opacityLow)
        }
        .frame(height: 35)
        .padding(.top, topSafeAreaSize + Constants.paddingSmall)
        .padding(.horizontal, Constants.paddingStandard)
      }
      FilterSelectionScrollView()
    }
    .ignoresSafeArea()
    .background(Color.spotifyMediumGray.shadow(color: .black, radius: 10).ignoresSafeArea())
    Spacer()
  }

  private struct MyLibraryProfileImageAndTitle: View {
    @EnvironmentObject var myLibraryVM: MyLibraryViewModel

    var body: some View {
      Circle()
        .fill(Color.spotifyMediumGray)
        .overlay(Group {
          let userName = myLibraryVM.mainVM.currentUserProfileInfo?.displayName ?? ""
          let userProfileImageURL = myLibraryVM.mainVM.currentUserProfileInfo?.imageURL ?? "S"

          if userProfileImageURL != "" {
            RemoteImage(urlString: userProfileImageURL)
          } else {
            Color.spotifyGreen
              .overlay(Text(String(userName.first! /* get first letter */))
                        .fontWeight(.bold).foregroundColor(.black))
          }
        })
        .mask(Circle())
        .scaledToFit()
      Text("My Library")
        .font(.avenir(.black, size: Constants.fontMedium))
    }
  }

  private struct FilterSelectionScrollView: View {
    @EnvironmentObject var myLibraryVM: MyLibraryViewModel

    var scale: CGFloat {
      let scrollScale = myLibraryVM.currentScrollPosition / UIScreen.main.bounds.height * 100
      return scrollScale <= Constants.paddingSmall ? scrollScale : Constants.paddingSmall
    }

    var opacityScale: CGFloat {
      let scrollScale = myLibraryVM.currentScrollPosition / UIScreen.main.bounds.height * 15
      return scrollScale <= 1 ? scrollScale : 1
    }

    var body: some View {
      ScrollView(.horizontal, showsIndicators: false) {
        Group {

          HStack(spacing: Constants.spacingSmall) {
            FilterCapsuleButton(text: "All", mediaType: nil)
            FilterCapsuleButton(text: "Playlists", mediaType: .playlist)
            FilterCapsuleButton(text: "Artists", mediaType: .artist)
            FilterCapsuleButton(text: "Albums", mediaType: .album)
            FilterCapsuleButton(text: "Shows", mediaType: .show)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, Constants.paddingStandard)
        }
      }
      .padding(.top, Constants.paddingSmall - scale)
      .opacity(1 - opacityScale)
      .padding(.bottom, -5)
    }
  }

  private struct FilterCapsuleButton: View {
    @EnvironmentObject var myLibraryVM: MyLibraryViewModel
    var text: String
    var mediaType: SpotifyModel.MediaTypes?
    var isTapped: Bool { myLibraryVM.selectedMediaTypeFilter == mediaType }

    let height: CGFloat = 35
    var scale: CGFloat {
      let scrollScale = myLibraryVM.currentScrollPosition / UIScreen.main.bounds.height * height * 10
      return scrollScale <= height ? scrollScale : height
    }

    var body: some View {
      Button(action: {
        myLibraryVM.selectedMediaTypeFilter = mediaType
      }) {
        Text(text)
          .font(.avenir(.medium, size: Constants.fontXSmall))
          .padding(.horizontal, Constants.paddingSmall)
          .foregroundColor(.white)
          .frame(height: height - scale)
          .opacity(isTapped ? 1 : Constants.opacityLow)
          // if isTapped -> show green filled background, else show white stroked border
          .background(isTapped ? Capsule().strokeBorder(Color.clear) : Capsule().strokeBorder(Color.white))
          .background(isTapped ? Capsule().foregroundColor(.spotifyGreen) : Capsule().foregroundColor(.clear))
      }
      .buttonStyle(PlainButtonStyle())
    }
  }

}


