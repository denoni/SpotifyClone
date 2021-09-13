//
//  AuthWebView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import SwiftUI
import WebKit

struct AuthScreenWebView: View {
  var url: String

  var body: some View {
    WebView(url: URL(string: url))
  }
}

struct WebView: UIViewRepresentable {
  let url: URL?

  private let webView = WKWebView()

  func makeUIView(context: Context) -> some UIView {
    return webView
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    guard let url = url else {
      return
    }
    webView.load(URLRequest(url: url))
  }
}
