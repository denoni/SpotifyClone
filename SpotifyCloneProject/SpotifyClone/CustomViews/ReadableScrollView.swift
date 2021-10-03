//
//  ReadableScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/3/21.
//

import SwiftUI

struct ReadableScrollView<Content: View>: View {
  @Binding var currentPosition: CGFloat
  @ViewBuilder var content: Content

  var body: some View {
    ScrollView(showsIndicators: false) {
      Group {
        content
      }
      .background(GeometryReader {
          Color.clear.preference(key: ViewOffsetKey.self,
              value: -$0.frame(in: .named("scroll")).origin.y)
      })
      .onPreferenceChange(ViewOffsetKey.self) { currentPosition = $0 }
    }
    .disabledBouncing()
    .coordinateSpace(name: "scroll")
  }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
