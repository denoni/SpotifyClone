//
//  RemoteView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import SwiftUI

struct RemoteImage: View {

  private class Loader: ObservableObject {
    var data = Data()

    init(url: String) {
      guard let parsedURL = URL(string: url) else {
        fatalError("Invalid URL: \(url)")
      }

      URLSession.shared.dataTask(with: parsedURL) { data, response, error in
        if let data = data, data.count > 0 { self.data = data }
        DispatchQueue.main.async { self.objectWillChange.send() }
      }.resume()
    }
  }

  @StateObject private var loader: Loader

  init(url: String) {
      _loader = StateObject(wrappedValue: Loader(url: url))
  }

  var body: some View {
    if let image = fetchedImage() {
      image
        .resizable()
    } else {
      ProgressView()
        .padding(10)
    }
  }

  private func fetchedImage() -> Image? {
    if let image = UIImage(data: loader.data) {
      return Image(uiImage: image)
    } else { return nil }
  }

}
