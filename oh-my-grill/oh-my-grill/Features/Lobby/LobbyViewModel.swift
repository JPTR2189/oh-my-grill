//
//  LobbyViewModel.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 26/11/25.
//

import Foundation

final class LobbyViewModel: LobbyViewModelProtocol {
    let transport: any TransportSessionProtocol

    var players: Int {
        return transport.connectedPeers.count + 1
    }
    
    var playerLimit: Int {
        return transport.playersNumber
    }
        
    init(transport: any TransportSessionProtocol) {
        self.transport = transport
    }
}
