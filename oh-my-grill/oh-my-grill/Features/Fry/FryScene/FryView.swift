//
//  FryView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 27/11/25.
//

import SwiftUI
import SpriteKit

struct FryView: View {
    
    @State var vm: FryViewModelProtocol
    @State var scene: FryScene
    
    @State var currentFry: SKIngredient?
    
    @State var firstEntry: Bool
    
    let initialScene: FryScene?
    
    init(vm: FryViewModelProtocol, entry: Bool = false) {
        self.vm = vm
        self.firstEntry = entry
        self.initialScene = FryScene(size: .init(width: 800, height: 800), session: vm.session)
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
                initialScene?.onFryerCollision = startMiniGame(_:)
                
            }
            .sheet(isPresented: $vm.nextView) {
                if let ingredient = currentFry {
                    CutMiniGameView(vm: CutMiniGameViewModel(session: vm.session), ingredient: ingredient)
                    //TODO: Call the Fry miniGame
                }
            }
        }
        
    }
    
    func startMiniGame(_ ingredient: SKIngredient) {
        currentFry = ingredient
        vm.nextView = true
    }
}
