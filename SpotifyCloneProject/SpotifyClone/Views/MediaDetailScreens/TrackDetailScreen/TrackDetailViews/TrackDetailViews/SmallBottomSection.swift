//
//  SmallBottomSection.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

struct SmallBottomSection: View {
  var isSmallDisplay: Bool = false

  var body: some View {
    HStack {
      Image("devices")
        .resizeToFit()
        .frame(width: isSmallDisplay ? 25 : 30)
      Spacer()
      Image("playlist")
        .resizeToFit()
        .padding(.vertical, 3)
        .frame(width: isSmallDisplay ? 25 : 30)
    }
  }
}
