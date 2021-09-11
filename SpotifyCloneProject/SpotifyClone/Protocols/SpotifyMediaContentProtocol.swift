//
//  SpotifyMediaContentProtocol.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import SwiftUI

protocol SpotifyMediaContentProtocol {
  var title: String { get set }
  var author: String { get set }
  var coverImage: Image { get set }
  var isPodcast: Bool { get set }
}
