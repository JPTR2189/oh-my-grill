//
//  CutView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 27/11/25.
//

import SwiftUI
import SpriteKit

struct CutView: View {
    
    @State var vm: CutViewModel
    @State var scene: CutScene
    
    @State var currentCut: SKIngredient?
    
    @State var firstEntry: Bool
    
    let initialScene: CutScene?
    
    init(vm: CutViewModel, entry: Bool = false) {
        self.vm = vm
        self.firstEntry = entry
        self.initialScene = CutScene(size: .init(width: 800, height: 800), session: vm.session)
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
                initialScene?.onKnifeCollision = startMiniGame(_:)
                
            }
            .sheet(isPresented: $vm.nextView) {
                if let ingredient = currentCut {
                    CutMiniGameView(vm: CutMiniGameViewModel(session: vm.session), ingredient: ingredient)
                        .interactiveDismissDisabled()
                }
            }
        }
        
    }
    
    func startMiniGame(_ ingredient: SKIngredient) {
        currentCut = ingredient
        vm.nextView = true
    }
}
