//
//  ChefView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 24/11/25.
//

import SwiftUI
import SpriteKit

struct ChefView: View {
    @State var vm: ChefViewModel
    
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
            
            // MARK: Round Info
            if let round = vm.round {
                RoundInfo(round: round)
                    .padding(.leading)
                    .padding(.top, 16)
            }
            
            // MARK: Orders
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(vm.orders) { order in
                        OrderCard(order: order)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
        }
    }
}
