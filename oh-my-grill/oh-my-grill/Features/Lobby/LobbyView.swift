//
//  LobbyView.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 25/11/25.
//

import SwiftUI

struct LobbyView: View {
    
    let transport: any TransportSessionProtocol
    
    @State private var nextView: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                Text("Lobby View")
                    .font(.largeTitle)
                
                Text("Waiting for host to start the game")
            }
            .onAppear {
                transport.setNotificationHandler(self)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $nextView) {
                PlayerAssignView()
            }
        }
    }
}

// MARK: -
extension LobbyView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .nextView:
            self.nextView = true
            
        default: break
        }
    }
}
