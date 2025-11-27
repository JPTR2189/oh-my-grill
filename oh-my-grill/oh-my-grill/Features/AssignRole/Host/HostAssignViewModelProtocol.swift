//
//  HostAssignViewModelProtocol.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 25/11/25.
//

import Foundation
import MultipeerConnectivity

protocol HostAssignViewModelProtocol {
    var transport: any TransportSessionProtocol { get }
    var assignedRoles: [MCPeerID: StationRole] { get set }
    
    var players: Int { get }
    var playerLimit: Int { get }
    
    var playerByRole: [String: String] { get }
    
    var gameSession: GameSession? { get }
    
    var allPlayernames: [String] { get }
    var unassignedPlayers: [String] { get }
    
    func assign(_ role: StationRole, to peer: MCPeerID)
    func assign(_ role: String, to peer: String)
    func startGameIfReady()
}
