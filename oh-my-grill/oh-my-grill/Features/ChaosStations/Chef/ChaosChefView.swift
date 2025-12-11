//
//  ChefView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 24/11/25.
//

import SpriteKit
import SwiftUI

struct ChaosChefView: View {
    @Bindable var vm: ChaosChefViewModel

    @State var scene: ChaosChefScene

    init(vm: ChaosChefViewModel) {
        self.vm = vm
        _scene = State(
            wrappedValue: ChaosChefScene(
                size: .init(width: 800, height: 800),
                session: vm.session,
                check: vm.check(_:)
            )

        )
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
                        
                        ForEach(vm.orders) { order in
                            OrderCard(order: order)
                                .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .opacity.animation(.easeOut(duration: 0.2))))
                                
                                .zIndex(1)
                        }

                        
                        
                    }
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: vm.orders.map { $0.id })
                    
                    OrdersCount(quantity: vm.moreOrders, Isvisible: vm.moreOrders > 0)
                        .padding(.top, 26)
                    
                    Spacer()

                    if let round = vm.round {
                        RoundInfo(round: round)
                            .disabled(true)
                    }
                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .allowsHitTesting(false)
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
                    FeedbackView(round: round, session: vm.session)
                }
            }
        }

        .onAppear {
            scene.startSpawning()
//            scene.dropBurger()
            vm.session.setNotificationHandler(self)
            vm.startGame()
        }
        .onDisappear {
            scene.stopSpawning()
        }
        .ignoresSafeArea(.all)
    }
}


// MARK: - Notification delegate
extension ChaosChefView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .gameMove(let payload):

            print("Parcel entered \(vm.session.myRole)'s view")
            
            scene.spawnIngredient(payload.ingredient)

        default:
            break
        }
    }

}
