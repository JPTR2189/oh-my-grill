//
//  ChefView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 24/11/25.
//

import SwiftUI
import SpriteKit

struct ChefView: View {
    @Bindable var vm: ChefViewModel
    
    var body: some View {
        ZStack (alignment: .top){
            
            // MARK: Sprite Scene
            SpriteView(
                scene: {
                    let scene = ChefScene(size: CGSize(width: 800, height: 600))
                    scene.scaleMode = .resizeFill
                    return scene
                }(),
                preferredFramesPerSecond: 60,
                options: [.ignoresSiblingOrder]
            )
            .ignoresSafeArea()
            
            //MARK: Round Info
            VStack {
                HStack {
                    if let order = vm.orders.first {
                        OrderCard(order: order)
                    }
                    
                    Spacer()
                    
                    if let round = vm.round {
                        RoundInfo(round: round)
                    }
                }
                Spacer()
            }
            .padding(.top, 0)
            .padding(.trailing, 0)
            .padding(.leading, 0)
        }
        .ignoresSafeArea(edges: .all)
    }
}
