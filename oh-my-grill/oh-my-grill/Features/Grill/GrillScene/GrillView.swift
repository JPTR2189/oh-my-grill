//
//  GrillView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 02/12/25.
//

import SwiftUI
import SpriteKit

struct GrillView: View {
    
    @State var vm: GrillViewModel
    @State var scene: GrillScene
    
    @State var currentGrill: SKIngredient?
    
    @State var firstEntry: Bool
    
    let initialScene: GrillScene?
    
    init(vm: GrillViewModel, entry: Bool = false) {
        self.vm = vm
        self.firstEntry = entry
        self.initialScene = GrillScene(size: .init(width: 800, height: 800), session: vm.session)
        
        //Identifies the grill collision and calls the next scene
        _scene = State(wrappedValue: initialScene!)
    }
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .topTrailing) {
                
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
                    if let round = vm.round {
                        RoundNumber(round: round)
                    }
                }
                .padding(.top, 0)
                .padding(.trailing, 0)
                .padding(.leading, 0)
            }
            .ignoresSafeArea()
            .onAppear {
//                vm.session.setNotificationHandler(self)
                initialScene?.onGrillCollision = startMiniGame(_:)
            }
            .sheet(isPresented: $vm.nextView) {
                if let ingredient = currentGrill {
                    GrillMiniGameView(vm: GrillMiniGameViewModel(session: vm.session, ingredient: ingredient))
                }
            }
        }
        
    }
    
    func startMiniGame(_ ingredient: SKIngredient) {
        currentGrill = ingredient
        vm.nextView = true
    }
}

//#Preview {
//    GrillView()
//}
