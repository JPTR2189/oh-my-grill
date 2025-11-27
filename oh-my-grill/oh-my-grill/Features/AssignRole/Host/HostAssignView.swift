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
    
    @State private var nextView: Bool = false
    
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
            .fullScreenCover(isPresented: $nextView) {
                if let gameSession = vc.gameSession {
                    ChefView(vm: ChefViewModel(session: gameSession))
                }
            }
        }
        .onAppear {
            vc.transport.setNotificationHandler(self)
        }
    }
}

// MARK: - Notification Delegate
extension HostAssignView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .nextView:
            self.nextView = true

        default: break
        }
    }
}
