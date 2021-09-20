//
//  RemoteView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

import SwiftUI

struct RemoteImage: View {
  @ObservedObject var remoteImageModel: RemoteImageModel

  init(urlString: String) {
    remoteImageModel = RemoteImageModel(urlString: urlString)
  }

  var body: some View {
    if remoteImageModel.image == nil {
      ProgressView()
        .padding()
    } else {
      Image(uiImage: remoteImageModel.image!)
        .resizable()
    }
  }
}
class RemoteImageModel: ObservableObject {
  @Published var image: UIImage?
  var urlString: String?
  var imageCache = ImageCache.getImageCache()

  init(urlString: String) {
    self.urlString = urlString
    loadImage()
  }

  func loadImage() {
    if loadImageFromCache() {
      return
    }
    loadImageFromUrl()
  }

  func loadImageFromCache() -> Bool {
    guard let urlString = urlString else {
      return false
    }

    guard let cacheImage = imageCache.get(forKey: urlString) else {
      return false
    }

    image = cacheImage
    return true
  }

  func loadImageFromUrl() {
    guard let urlString = urlString else {
      return
    }

    let task = URLSession.shared.dataTask(with: URL(string: urlString)!,
                                          completionHandler: getImageFromResponse(data:response:error:))
    task.resume()
  }


  func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
    guard error == nil else {
      print("Error: \(error!)")
      return
    }
    guard let data = data else {
      print("No data found")
      return
    }

    DispatchQueue.main.async {
      guard let loadedImage = UIImage(data: data) else {
        return
      }
      self.imageCache.set(forKey: self.urlString!, image: loadedImage)
      self.image = loadedImage
    }
  }
}

class ImageCache {
  var cache = NSCache<NSString, UIImage>()

  func get(forKey key: String) -> UIImage? {
    return cache.object(forKey: NSString(string: key))
  }

  func set(forKey key: String, image: UIImage) {
    cache.setObject(image, forKey: NSString(string: key))
  }
}

extension ImageCache {
  private static var imageCache = ImageCache()
  static func getImageCache() -> ImageCache {
    return imageCache
  }
}
