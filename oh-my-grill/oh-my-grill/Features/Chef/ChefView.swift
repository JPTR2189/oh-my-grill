//
//  ChefView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 24/11/25.
//

import SwiftUI
import SpriteKit

struct ChefView: View {
    var body: some View {
            SpriteView(
                scene: {
                    let scene = ChefScene(size: CGSize(width: 800, height: 600))
                    scene.scaleMode = .resizeFill
                    scene.backgroundColor = .white
                    
                    return scene
                }(),
                preferredFramesPerSecond: 60, options: [.ignoresSiblingOrder]
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()

    }
}
