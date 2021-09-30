//
//  ArtistMediaHorizontalScrollView.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/29/21.
//

import SwiftUI

struct ArtistMediaHorizontalScrollView: View {
//  @StateObject var homeVM: HomeViewModel
//  @State var medias: [SpotifyModel.MediaItem]
  var sectionTitle: String

  var medias = [("Ariana Grande: Best Of", "https://i.scdn.co/image/ab67706c0000bebb4d5b3fbd576a2254f137f5e1"),
                ("7 rings - Remixes", "https://i.scdn.co/image/ab67706c0000bebbf638023810b409475155d736"),
                ("Ariana Grande - all songs", "https://mosaic.scdn.co/640/ab67616d0000b27333342c57a9b2c4e04c97b3f5ab67616d0000b27356ac7b86e090f307e218e9c8ab67616d0000b2739508fb7ca2eedc0d98b9139fab67616d0000b273c3af0c2355c24ed7023cd394"),
                ("Ariana Grande Greatest Hits", "https://i.scdn.co/image/ab67706c0000bebb4ebad22677e6077e8bc8f725"),
                ("Old Songs From Ariana", "https://mosaic.scdn.co/640/ab67616d0000b27333342c57a9b2c4e04c97b3f5ab67616d0000b27356ac7b86e090f307e218e9c8ab67616d0000b273deec12a28d1e336c5052e9aaab67616d0000b273ea28881e9e363244a4a2347b"),
                ("Fortnite Rift Tour Featuring Ariana Grande", "https://i.scdn.co/image/ab67706c0000bebbfca2a7cd812e1b38ea90a227"),
                ("Ariana Grande Clean Playlist", "https://i.scdn.co/image/ab67706c0000bebb24228cb4d50a046a35333546"),
                ("Ariana Grande Christmas Songs🎄❄️", "https://i.scdn.co/image/ab67706c0000bebbb09812dea8102cfa36eb63a2"),
                ("Ariana Grande Hits 🌈", "https://i.scdn.co/image/ab67706c0000bebbefc0716f9891205ec6568d43"),
                ("Ariana Grande Live Album", "https://i.scdn.co/image/ab67616d0000b273d0f561d8bb164349dccbfde4"),]

  var body: some View {
    VStack(alignment: .center, spacing: spacingSmallItems) {
      Text(sectionTitle)
        .spotifyTitle()
        .lineLimit(1)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(alignment: .top, spacing: spacingBigItems) {
          ForEach(0 ..< 10) { index in
            SmallSongItem(imageURL: medias[index].1,
                          title: medias[index].0)
            // TODO: On tap gesture
          }
        }
      }
    }
    .frame(height: 250)
  }
}
