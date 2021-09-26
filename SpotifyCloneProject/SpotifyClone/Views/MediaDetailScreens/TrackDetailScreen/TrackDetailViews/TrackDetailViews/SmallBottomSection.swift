//
//  SmallBottomSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct SmallBottomSection: View {
  var body: some View {
    HStack {
      Image("devices")
        .resizeToFit()
        .padding(.vertical, 3)
      Spacer()
      Image("playlist")
        .resizeToFit()
        .padding(.vertical, 3)
    }
    .frame(height: 32,
           alignment: .center)
  }
}
