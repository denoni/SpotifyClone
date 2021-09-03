//
//  SpotifyTextField.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/2/21.
//

import SwiftUI

struct SpotifyTextField: View {
  var leadingIcon: Image = Image("search-unselected")
  var textInput: Binding<String>
  var placeholder: String

  var body: some View {
    HStack() {
      leadingIcon
        .resizeToFit()
        .padding(5)
        .colorMultiply(.black)
      TextField("", text: textInput)
        .modifier(PlaceholderStyle(showPlaceHolder: textInput.wrappedValue.isEmpty, placeholder: placeholder))
        .padding(.horizontal, 5)
    }
        .font(.avenir(.medium, size: 20))
        .foregroundColor(.black)
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(5)
  }

  private struct PlaceholderStyle: ViewModifier {
      var showPlaceHolder: Bool
      var placeholder: String

      public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
          if showPlaceHolder {
            Text(placeholder)
              .padding(.horizontal, 5)
              .foregroundColor(Color.black.opacity(0.3))
          }
          content
      }
    }
  }
}
