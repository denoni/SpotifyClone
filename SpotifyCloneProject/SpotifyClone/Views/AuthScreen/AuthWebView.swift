//
//  AuthSheetView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import SwiftUI
import WebKit

struct AuthSheetView: View {
  @ObservedObject var webViewModel: WebViewModel
  @Binding var showView: Bool
  @Binding var spotifyCode: String
  
  var body: some View {
    Group {
      if !webViewModel.exit {
        LoadingView(isLoading: self.$webViewModel.isLoading) {
          WebView(viewModel: self.webViewModel)
            .opacity(webViewModel.isLoading ? 0 : 1)
        }
      } else {
        ProgressView()
          .onAppear {
            showView = false
            spotifyCode = webViewModel.spotifyCode
          }
      }
    }.edgesIgnoringSafeArea(.bottom)
  }
  
}

struct WebView: UIViewRepresentable {
  // When the user opens the keyboard inside WebView,
  // a lot of errors will appear on terminal.
  // From what I've searched, the errors are
  // originated by a bug and won't affect the app.
  @ObservedObject var viewModel: WebViewModel
  let webView = WKWebView()
  
  func makeCoordinator() -> AuthCoordinator {
    AuthCoordinator(self.viewModel)
  }
  
  func updateUIView(_ uiView: UIView,
                    context: UIViewRepresentableContext<WebView>) {}
  
  func makeUIView(context: Context) -> UIView {
    self.webView.navigationDelegate = context.coordinator
    
    if let url = URL(string: self.viewModel.url) {
      self.webView.load(URLRequest(url: url))
    }
    
    return self.webView
  }
}
