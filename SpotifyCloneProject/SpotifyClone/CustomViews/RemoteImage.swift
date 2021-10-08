//
//  RemoteView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/14/21.
//

// Credits to SchwiftyUI for the majority of the code.

import SwiftUI

struct RemoteImage: View {
  @ObservedObject var remoteImageModel: RemoteImageModel
  var placeholderImage: String

  init(urlString: String,
       withPlaceholderURL placeholderURL: String = "https://bit.ly/3lx16mQ") {
    remoteImageModel = RemoteImageModel(urlString: urlString)
    placeholderImage = placeholderURL
  }

  var body: some View {
    if remoteImageModel.image == nil {
      if remoteImageModel.noImageFound == true {
        RemoteImage(urlString: placeholderImage)
      } else {
        ProgressView()
          .withSpotifyStyle(useDiscreetColors: true)
          .padding()
      }
    } else {
      Image(uiImage: remoteImageModel.image!)
        .resizable()
        .scaledToFill()
    }
  }
}

class RemoteImageModel: ObservableObject {
  @Published var image: UIImage?
  @Published var noImageFound = false
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
      DispatchQueue.main.async { self.noImageFound = true }
      return
    }
    guard urlString != "" else {
      DispatchQueue.main.async { self.noImageFound = true }
      return
    }

    let task = URLSession.shared.dataTask(with: URL(string: urlString)!,
                                          completionHandler: getImageFromResponse(data:response:error:))
    task.resume()
  }


  func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
    guard error == nil else {
      print("Error: \(error!)")
      DispatchQueue.main.async { self.noImageFound = true }
      return
    }
    guard let data = data else {
      print("No data found")
      DispatchQueue.main.async { self.noImageFound = true }
      return
    }

    if let response = response as? HTTPURLResponse {
      if response.statusCode != 200 {
        DispatchQueue.main.async { self.noImageFound = true }
      }
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
