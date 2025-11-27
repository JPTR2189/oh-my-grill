//
//  LobbyViewModelProtocol.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 26/11/25.
//

import Foundation

protocol LobbyViewModelProtocol {
    var transport: any TransportSessionProtocol { get }
    
    var players: Int { get }
    var playerLimit: Int { get }
}
