//
//  VideoFullscreenView.swift
//  Updraft
//
//  Created by Yanis Plumit on 20.10.2025.
//  Copyright © 2025 Apps with love AG. All rights reserved.
//

import SwiftUI
import AVKit

struct VideoFullscreenView: View {
    @Environment(\.dismiss) private var dismiss
    let url: URL
    private let player: AVPlayer
    
    init(url: URL) {
        self.url = url
        self.player = AVPlayer(url: url)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VideoPlayer(player: player)
                .ignoresSafeArea()
                .onAppear {
                    player.play()
                }

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                    .padding()
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    VideoFullscreenView(url: URL(string: "https://example.com/image.png")!)
}
