//
//  SpotifySlider.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/26/21.
//

import SwiftUI

// TODO: Make this a real functional slider
struct SpotifySlider: View {
  @State var durationInMs: Double
  var timeLeft: (min: String, sec: String) {
    let time = convertMsToMinAndSec(durationInMs: durationInMs)

    let minutes = String(time.min)
    var seconds: String {
      // Test if seconds has only one character
      if String(time.sec).count == 1 {
        // If it has, add a 0 in front. e.g. 9 -> 09
        return String("0\(time.sec)")
      } else {
        // If the value already has 2 characters, we don't need to do nothing
        return String(time.sec)
      }
    }
    return (minutes, seconds)
  }

  var body: some View {
    VStack(spacing: 2) {
      ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: 5)
          .fill(Color.white)
          .frame(height: 4, alignment: .center)
          .opacity(0.25)
        Circle()
          .scaledToFit()
      }
      .frame(height: 20)
      HStack {
        Text("0:00")
          .font(.avenir(.medium, size: 13))
          .foregroundColor(.white)
        Spacer()
        Text("-\(timeLeft.min):\(timeLeft.sec)")
          .font(.avenir(.medium, size: 13))
          .foregroundColor(.white)
      }
      .padding(.horizontal, 3)
    }
  }

  func convertMsToMinAndSec(durationInMs: Double) -> (min: Int, sec: Int) {
    let seconds = durationInMs / 1000
    return ((Int(seconds) % 3600) / 60, (Int(seconds) % 3600) % 60)
  }
}
