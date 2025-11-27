//
//  PlayerAssignViewModelProtocol.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 26/11/25.
//

import Foundation
import MultipeerConnectivity

protocol PlayerAssignViewModelProtocol {
    var transport: any TransportSessionProtocol { get }
    var gameSession: GameSession? { get set }
    var playerLimit: Int { get }
    var players: Int { get }
    
    var assignedRoles: [MCPeerID: StationRole] { get set }
    var playerByRole: [String: String] { get }
}
