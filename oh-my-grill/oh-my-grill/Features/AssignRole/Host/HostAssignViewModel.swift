//
//  HostAssignViewModel.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 25/11/25.
//

import Foundation
import MultipeerConnectivity

final class HostAssignViewModel: HostAssignViewModelProtocol {
    var assignedRoles: [MCPeerID: StationRole] = [:]
    
    var gameSession: GameSession?
    
    var transport: any TransportSessionProtocol
    
    private var canStart: Bool {
        let peers = transport.connectedPeers
        let requiredPlayers = transport.playersNumber
        let requiredPeers = requiredPlayers - 1

        let cond1 = peers.count == requiredPeers
        if !cond1 { print("failed condition 1") }

        let cond2 = assignedRoles.count == requiredPlayers
        if !cond2 {
            print("failed condition 2")

            print(assignedRoles)
        }

        let cond3 = Set(assignedRoles.values).count == requiredPlayers
        if !cond3 {
            print("failed condition 3")
            print(assignedRoles)
        }

        return cond1 && cond2 && cond3
    }

    
    init(transport: TransportSessionProtocol) {
        self.transport = transport
        self.assignedRoles[transport.myPeerID] = .chef
    }
    
    func assign(_ role: StationRole, to peer: MCPeerID) {
        for (p, r) in assignedRoles where r == role && p != peer {
            assignedRoles[p] = nil
        }
        assignedRoles[peer] = role
    }
    
    func startGameIfReady() {
        guard canStart else {
            print("Can't start game")
            return
        }
        
        let playerIDs =
            [transport.myPeerID.displayName]
            + transport.connectedPeers.map(\.displayName)
        
        let rolesByID = assignedRoles.reduce(into: [String: StationRole]()) {
            dict,
            pair in
            dict[pair.key.displayName] = pair.value
        }

        let payload = GameConfigPayload(
            mode: .classic,
            players: playerIDs,
            roles: rolesByID
        )

        let message = MPCMessage.gameConfig(payload)
        transport.send(message)

        print("Initializing gameSession on host, should start the game")
        self.gameSession =  GameSession(
            transport: transport,
            config: payload
        )
    }
}

