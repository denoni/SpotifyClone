//
//  MediaDescription.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI

struct MediaDescription: View {
  @State var description: String
  @State var lineLimit: Int? = 2

  // that means that read more button was clicked
  @State var isExpanded = false

  // that means that text is small enough to fit the line limit
  @State var textAlreadyFits = true

  var body: some View {

    VStack(alignment: .leading, spacing: 0) {
      Text(description)
        .font(.avenir(.medium, size: Constants.fontSmall))
        .opacity(Constants.opacityStandard)
        .lineLimit(lineLimit)
        .background(
          GeometryReader { geometry in
            Color.clear.onAppear {
              textAlreadyFits = doesTextAlreadyFit(geometry)
            }
          })
      if !textAlreadyFits {
        Button(action: {
          if isExpanded {
            lineLimit = 2
            isExpanded = false
          } else {
            lineLimit = .none
            isExpanded = true
          }
        }, label: {
          Text(isExpanded ? "Read less" : "Read more")
            .font(.avenir(.heavy, size: Constants.fontSmall))
            .foregroundColor(.white)
        })
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }

  }

  // Credits to @bhuemer (stackoverflow) for the majority of the code below.

  private func doesTextAlreadyFit(_ geometry: GeometryProxy) -> Bool {
    // Calculate the bounding box we'd need to render the
    // text given the width from the GeometryReader.
    let totalOccupied = description.boundingRect(
      with: CGSize(
        width: geometry.size.width,
        height: .greatestFiniteMagnitude
      ),
      options: .usesLineFragmentOrigin,
      attributes: [.font: UIFont.avenir(.medium, size: Constants.fontSmall)],
      context: nil
    )

    if Int(totalOccupied.size.height) > Int(geometry.size.height) {
      return false
    } else {
      return true
    }
  }

}
