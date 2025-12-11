//
//  FryView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 27/11/25.
//

import SpriteKit
import SwiftUI

struct FryView: View {

    @State var vm: FryViewModelProtocol
    @State var scene: FryScene

    @State var currentFry: SKIngredient?

    @State var firstEntry: Bool

    @State private var goToFeedback = false
    @State private var showAlert = false

    let initialScene: FryScene?

    init(vm: FryViewModelProtocol, entry: Bool = false) {
        self.vm = vm
        self.firstEntry = entry
        self.initialScene = FryScene(
            size: .init(width: 800, height: 800),
            session: vm.session
        )
        _scene = State(wrappedValue: initialScene!)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {

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
                initialScene?.onFryerCollision = startMiniGame(_:)
            }
            .sheet(isPresented: $vm.nextView) {
                if let ingredient = currentFry {
                    FryMinigameView(
                        viewModel: FryMinigameViewModel(session: vm.session),
                        ingredient: ingredient
                    )
                    .interactiveDismissDisabled()
                }
            }
            .navigationDestination(isPresented: $goToFeedback) {
                if let round = vm.session.finishedRound {
                    FeedbackView(round: round, session: vm.session)
                }
            }
            .alert("Host left the game", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    UIApplication.shared.switchToHome(view: HomeView())
                }
            } message: {
                Text(
                    "The host lost connection to the game. Sending you to the home page"
                )
            }
        }

    }

    func startMiniGame(_ ingredient: SKIngredient) {
        currentFry = ingredient
        vm.nextView = true
    }
}

extension FryView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .roundFinished(let payload):
            vm.session.currentRound?.points = payload.points
            vm.session.finishRound()
            goToFeedback = true

        case .endGame:
            print("End game")
            showAlert = true

        default:
            break
        }
    }
}
