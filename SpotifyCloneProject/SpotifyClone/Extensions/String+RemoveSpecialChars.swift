//
//  String+RemoveSpecialChars.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/5/21.
//

import Foundation

extension String {

  var removeSpecialChars: String {
    let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
    let word = self.folding(options: .diacriticInsensitive, locale: .current)
    return word.filter {okayChars.contains($0) }
  }
}
