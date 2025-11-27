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

    @State var scene: ChefScene
    
    init(vm: ChefViewModel) {
        self.vm = vm
        _scene = State(wrappedValue: ChefScene(size: .init(width: 800, height: 800), session: vm.session))
    }
    
    var body: some View {
        ZStack (alignment: .top){
            
            // MARK: Sprite Scene
            SpriteView(
                scene: {
                    scene
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
        .onAppear {
            vm.session.setNotificationHandler(self)
        }
        .ignoresSafeArea(edges: .all)
    }
}

// MARK: - Notification delegate
extension ChefView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .gameMove(let payload):
            
            let dx = CGFloat(payload.x)
            let sign: CGFloat = dx >= 0 ? 1 : -1

            let newDistance = max(0, abs(dx) - 21)

            let newX = scene.frame.midX + sign * newDistance

            let point = CGPoint(x: newX, y: CGFloat(payload.y))
            print("Parcel entered \(vm.session.myRole)'s view")
            scene.spawnBall(at: point, goingTo: payload.side)
            
        default:
            break
        }
    }
    
    
}
