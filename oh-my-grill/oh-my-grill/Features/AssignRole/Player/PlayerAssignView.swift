//
//  PlayerAssignView.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 25/11/25.
//

import SwiftUI

struct PlayerAssignView: View {
    
    // TODO: Move to ViewModel
    private var transport: any TransportSessionProtocol
    @State private var gameSession: GameSession?
    /***/
    
    public init(transport: any TransportSessionProtocol) {
        self.transport = transport
    }

    var body: some View {

        NavigationStack {
            Group {

                Text("Player Assign Viwe")
                    .font(.largeTitle)

                Text("Waiting for host to do assign roles")
            }
            .navigationBarBackButtonHidden(true)
            .fullScreenCover(isPresented: Binding(get: { gameSession != nil }, set: { _ in })) {
                if let session = self.gameSession {
                    GameView(session: session)
                }
            }
        }
        .onAppear {
            transport.setNotificationHandler(self)
        }
    }
}

// MARK: -
extension PlayerAssignView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .gameConfig(let payload):
            print("Game Config received")
            self.gameSession = GameSession(transport: self.transport, config: payload)
            
        default: break
        }
    }
}
