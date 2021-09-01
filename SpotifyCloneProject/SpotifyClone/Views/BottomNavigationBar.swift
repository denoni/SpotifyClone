//
//  BottomNavigationBar.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/1/21.
//

import SwiftUI

struct BottomNavigationBar: View {
  let grayLighter = Color(red: 0.196, green: 0.196, blue: 0.196)
  let grayDarker = Color(red: 0.153, green: 0.153, blue: 0.153)

  let grayHeavyLight = Color(red: 0.325, green: 0.325, blue: 0.325)

  var body: some View {
    Spacer()
    ZStack {
      VStack(spacing: 0) {
        Spacer()
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
