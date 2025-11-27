//
//  PlayerAssignViewModel.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 26/11/25.
//

import Foundation
import MultipeerConnectivity

final class PlayerAssignViewModel: PlayerAssignViewModelProtocol {
    var assignedRoles: [String : StationRole] = [:]
    
    var playerByRole: [String: String] {
        var result: [String: String] = [:]
        
        for role in StationRole.allCases {
            if role == .notSet { continue }
            
            let playerName = assignedRoles.first { $0.value == role }?.key
            
            result[role.displayName] = playerName ?? ""
        }
        
        return result
    }
    
    var transport: any TransportSessionProtocol
    var gameSession: GameSession?
    
    
    var players: Int {
        return transport.connectedPeers.count + 1
    }
    
    var playerLimit: Int {
        return transport.playersNumber
    }

    public init(transport: any TransportSessionProtocol) {
        self.transport = transport
    }
}
