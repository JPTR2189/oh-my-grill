//
//  CutView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 27/11/25.
//

import SwiftUI
import SpriteKit

struct ChaosCutView: View {
    
    @State var vm: ChaosCutViewModel
    @State var scene: ChaosCutScene
    
    @State var currentCut: SKIngredient?
    
    @State var firstEntry: Bool
    
    @State private var goToFeedback = false
    
    let initialScene: ChaosCutScene?
    
    init(vm: ChaosCutViewModel, entry: Bool = false) {
        self.vm = vm
        self.firstEntry = entry
        self.initialScene = ChaosCutScene(size: .init(width: 800, height: 800), session: vm.session)
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
                .allowsHitTesting(false)
                .padding(.top, 0)
                .padding(.trailing, 0)
                .padding(.leading, 0)
            }
            .ignoresSafeArea()
            .onAppear {
                vm.session.setNotificationHandler(self)
                initialScene?.onKnifeCollision = startMiniGame(_:)
            }
            .sheet(isPresented: $vm.nextView) {
                if let ingredient = currentCut {
                    CutMiniGameView(vm: CutMiniGameViewModel(session: vm.session), ingredient: ingredient)
                        .interactiveDismissDisabled()
                }
            }
            .navigationDestination(isPresented: $goToFeedback) {
                if let round = vm.session.finishedRound {
                    FeedbackView(round: round, session: vm.session)
                }
            }
            .onAppear {
                scene.startSpawning()
            }
            .onDisappear {
                scene.stopSpawning()
            }
        }
        
    }
    
    func startMiniGame(_ ingredient: SKIngredient) {
        currentCut = ingredient
        vm.nextView = true
    }
}

extension ChaosCutView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .roundFinished(let payload):
            vm.session.currentRound?.points = payload.points
            vm.session.finishRound()
            goToFeedback = true
        default:
            break
        }
    }
}
