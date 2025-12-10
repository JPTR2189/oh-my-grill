//
//  GrillView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 02/12/25.
//

import SwiftUI
import SpriteKit

struct ChaosGrillView: View {
    
    @State var vm: ChaosGrillViewModel
    @State var scene: ChaosGrillScene
    
    @State var currentGrill: SKIngredient?
    
    @State private var grilledIngredient: SKIngredient?
    @State private var isSecondSide = false
    
    @State var firstEntry: Bool
    
    @State private var goToFeedback = false
    
    let initialScene: ChaosGrillScene?
    
    init(vm: ChaosGrillViewModel, entry: Bool = false) {
        self.vm = vm
        self.firstEntry = entry
        self.initialScene = ChaosGrillScene(size: .init(width: 800, height: 800), session: vm.session)
        
        //Identifies the grill collision and calls the next scene
        _scene = State(wrappedValue: initialScene!)
    }
    
    var body: some View {
        NavigationStack{
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
                
                // MARK: Timer Overlay
                if vm.session.showTimer {
                    ProgressTimer(
                        duration: 3.0,
                        lineWidth: 12,
                        startColor: isSecondSide ? .green : .yellow,
                        endColor: isSecondSide ? .red : .green
                    ) {
                        vm.session.showTimer = false
                        
                        if !isSecondSide {
                            currentGrill = grilledIngredient
                            vm.nextView = true
                            isSecondSide = true
                        } else {
                            if grilledIngredient?.ingredient.state != .cheesed {
                                grilledIngredient?.ingredient.state = .burnt
                            }
                        }
                    }
                    .frame(width: 30, height: 30)
                    .padding(.top, 155)
                    .padding(.trailing, 340)
                }
                
                //MARK: Round Info
                VStack {
                    if let round = vm.round {
                        RoundNumber(round: round)
                            .disabled(true)
                    }
                }
                .padding(.top, 0)
                .padding(.trailing, 0)
                .padding(.leading, 0)
            }
            .ignoresSafeArea()
            .onAppear {
                vm.session.setNotificationHandler(self)
                initialScene?.onGrillCollision = startMiniGame(_:)
            }
            .sheet(isPresented: $vm.nextView, onDismiss: secondSideTimer) {
                if let ingredient = currentGrill {
                    GrillMiniGameView(vm: GrillMiniGameViewModel(session: vm.session, ingredient: ingredient)).interactiveDismissDisabled()
                }
            }
            .navigationDestination(isPresented: $goToFeedback) {
                if let round = vm.session.finishedRound {
                    FeedbackView(round: round)
                }
            }
        }
    }
    
    func startMiniGame(_ ingredient: SKIngredient) {
        grilledIngredient = ingredient
        isSecondSide = false
        grilledIngredient?.isCooking = true
        vm.session.showTimer = true
    }
    
    func secondSideTimer() {
        guard let ingredient = grilledIngredient,
              ingredient.ingredient.state == .cooked
        else { return }
        grilledIngredient?.isCooking = false
        vm.session.showTimer = true
    }
}


extension ChaosGrillView: MPCNotificationDelegate {
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

//#Preview {
//    GrillView()
//}
