//
//  SecondsToHMS.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/4/21.
//

import Foundation

class SecondsToHMS: NSObject {

  private static var timeHMSFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = [.pad]
    return formatter
  }()

  static func formatSecondsToHMS(_ seconds: Double) -> String {
    guard !seconds.isNaN,
          let text = timeHMSFormatter.string(from: seconds) else {
      return "00:00"
    }

    return text
  }

}
