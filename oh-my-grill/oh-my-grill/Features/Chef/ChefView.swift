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
        NavigationStack {
            
            ZStack(alignment: .topTrailing) {
                
                SpriteView(
                    scene: scene,
                    preferredFramesPerSecond: 60,
                    options: [.ignoresSiblingOrder]
                )
                .ignoresSafeArea()
                
                HStack(alignment: .top, spacing: 0){
                    
                    HStack(spacing: 9) {
                        
                        if let order = vm.orders.first {
                            OrderCard(order: order)
                                .padding(.leading, 20)

                            OrderCard(order: order)
                            
                            
                            OrderCard(order: order)
                           
                        }
                        
                        
                    }
                    
                    RoundTimer(round: Round(number: 1, minPoints: 1000), roundSide: .left)
                        .padding(.top, 26)
                    
                    Spacer()
                    
                    if let round = vm.round {
                        RoundInfo(round: round)
                    }
                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .ignoresSafeArea()
            
            // MARK: Navigation
            .navigationDestination(
                isPresented: Binding(
                    get: { vm.session.finishedRound != nil },
                    set: { _ in vm.session.finishedRound = nil }
                )
            ) {
                if let round = vm.session.finishedRound {
                    FeedbackView(round: round)
                }
            }
        }
        
        .onAppear {
            vm.session.setNotificationHandler(self)
        }
        .ignoresSafeArea(.all)
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

#Preview {
    let vm = ChefViewModel(session: GameSession(transport: TransportSession(userName: "Teste"), config: GameConfigPayload(mode: .classic, players: ["1"], roles: ["2": .chef])))
    ChefView(vm: vm)
}

