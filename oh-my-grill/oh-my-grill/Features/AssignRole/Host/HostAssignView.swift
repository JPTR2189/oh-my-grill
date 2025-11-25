//
//  HostAssignView.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 25/11/25.
//

import SwiftUI
import MultipeerConnectivity

struct HostAssignView: View {
    
    private var vc: any HostAssignViewModelProtocol
    
    init(transport: TransportSessionProtocol) {
        self.vc = HostAssignViewModel(transport: transport)
    }
    
    var body: some View {
        NavigationStack {
            Text("Assign role")
                .font(.title)

            List {
                ForEach(vc.transport.connectedPeers, id: \.self) { peer in
                    HStack {
                        Text(peer.displayName)
                        Spacer()
                        Menu(vc.assignedRoles[peer]?.displayName ?? "Select role")
                        {
                            ForEach(StationRole.allCases, id: \.self) { role in
                                if role != .chef {
                                    Button(role.displayName) {
                                        vc.assign(role, to: peer)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Button("Start Game") {
                vc.startGameIfReady()
            }
            .fullScreenCover(
                isPresented: Binding(get: { vc.gameSession != nil }, set: { _ in })
            ) {
                if let gameSession = vc.gameSession {
                    GameView(session: gameSession)
                }
            }
        }
    }
}
