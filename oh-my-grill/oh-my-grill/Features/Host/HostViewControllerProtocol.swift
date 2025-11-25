//
//  HostViewControllerProtocol.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 21/11/25.
//

import Foundation

protocol HostViewControllerProtocol {
    var transport: any TransportSessionProtocol { get }
    var password: [String] { get }
    var rawPassword: String { get }
    
    func startGame()
}
