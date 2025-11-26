//
//  PlayerAssignViewModel.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 26/11/25.
//

import Foundation

final class PlayerAssignViewModel: PlayerAssignViewModelProtocol {
    
    var transport: any TransportSessionProtocol
    var gameSession: GameSession?
    
    var playerLimit: Int {
        return transport.playersNumber
    }

    public init(transport: any TransportSessionProtocol) {
        self.transport = transport
    }


}
