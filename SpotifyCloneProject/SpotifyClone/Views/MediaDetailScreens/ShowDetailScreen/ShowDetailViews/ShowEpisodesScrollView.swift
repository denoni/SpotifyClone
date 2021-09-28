//
//  ShowEpisodesScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/28/21.
//

import SwiftUI

struct ShowEpisodesScrollView: View {
  let arr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
  var body: some View {
    LazyVStack {
      ForEach(arr, id: \.self) { _ in
        VStack(alignment: .leading, spacing: 12) {
            HStack (alignment: .center, spacing: 15) {
              RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.spotifyMediumGray)
                .overlay(Image("joe-rogan-cover").resizeToFit())
                .mask(RoundedRectangle(cornerRadius: 10))
                .frame(width: 50, height: 50)
              Text("#1696 - Lex Fridman")
                .font(.avenir(.heavy, size: 18))
              Spacer()
            }

          Text("Lex Fridman is a AI researcher working on autonomous vehicles, human-robot interaction, and machine learning at MIT and beyond.")
            .font(.avenir(.medium, size: 14))
            .lineLimit(2)
            .opacity(0.7)
            .padding(.bottom, 5)

          Text("Yesterday • 1h 55m")
            .font(.avenir(.medium, size: 14))
            .opacity(0.6)
            .padding(.bottom, 5)

          HStack(spacing: 25) {
            Group {
              Circle()
                .foregroundColor(.clear)
                .overlay(Image("plus-circle").resizeToFit())
                .aspectRatio(contentMode: .fit)
              Circle()
                .foregroundColor(.clear)
                .overlay(Image("download-circle").resizeToFit())
                .aspectRatio(contentMode: .fit)
              Image("three-dots")
                .resizeToFit()
                .padding(.vertical, 3)
                .opacity(0.8)
            }
            Spacer()
            Circle()
              .foregroundColor(.black)
              .overlay(Image("circle-play").resizeToFit())
              .aspectRatio(contentMode: .fit)
              .frame(height: 35)
          }
          .frame(height: 25, alignment: .leading)
          Divider()
            .padding(.top, 5)
        }
        .frame(height: 200)
      }
    }
    .padding(.top, 15)
  }
}
