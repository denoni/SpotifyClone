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
          Image("plus")
            .resizeToFit()
            .padding(8)
            .opacity(Constants.opacityLow)
        }
        .frame(height: 35)
        .padding(.top, topSafeAreaSize + Constants.paddingSmall)
        .padding(.horizontal, Constants.paddingStandard)
      }
      FilterSelectionBar(currentViewModel: myLibraryVM)
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
}
