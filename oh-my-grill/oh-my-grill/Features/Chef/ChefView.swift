//
//  ChefView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 24/11/25.
//

import SwiftUI
import SpriteKit

struct ChefView: View {
    var vm: ChefViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // MARK: Sprite Scene
            SpriteView(
                scene: {
                    let scene = ChefScene(size: CGSize(width: 800, height: 600))
                    scene.scaleMode = .resizeFill
                    scene.backgroundColor = .texasWhite
                    return scene
                }(),
                preferredFramesPerSecond: 60,
                options: [.ignoresSiblingOrder]
            )
            .ignoresSafeArea()
            
            // MARK: Orders
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    OrderCard(order: vm.order)
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
        }
    }
}
