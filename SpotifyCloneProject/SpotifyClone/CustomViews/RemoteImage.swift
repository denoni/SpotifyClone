//
//  RemoteView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import SwiftUI

// TODO: Add cache

struct RemoteImage: View {
  @StateObject private var loader: Loader

  init(url: String) {
    _loader = StateObject(wrappedValue: Loader(urlSendByAPI: url))
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

  private class Loader: ObservableObject {
    var data = Data()
    var cacheImage = ImageCache.getImageCache()

    init(urlSendByAPI: String) {

      // Set parsedURL to a placeholder image url,
      // in case the url passed by the api is invalid.
      var url = "https://bit.ly/3lx16mQ"

      if !urlSendByAPI.isEmpty { url = urlSendByAPI }

      let cacheImageData = cacheImage.get(forKey: url)

      guard cacheImageData == nil else {
        print(">>> HAVE CACHE")
        self.data = Data(referencing: cacheImageData!)
        DispatchQueue.main.async { self.objectWillChange.send() }
        return
      }

      URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
        if let data = data, data.count > 0 {
          self.data = data
          self.cacheImage.set(forKey: url, imageData: NSData(data: data))
        }
        DispatchQueue.main.async { self.objectWillChange.send() }
      }.resume()
    }
  }

}

class ImageCache {
  var cache = NSCache<NSString, NSData>()

  func get(forKey key: String) -> NSData? {
    return cache.object(forKey: NSString(string: key))
  }

  func set(forKey key: String, imageData: NSData) {
    cache.setObject(imageData, forKey: NSString(string: key))
  }
}

extension ImageCache {
  private static var imageCache = ImageCache()
  static func getImageCache() -> ImageCache {
    return imageCache
  }
}
