//
//  HostViewController.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 21/11/25.
//

import Foundation

final class HostViewController: HostViewControllerProtocol {
    var password: [String] = []
    let transport: any TransportSessionProtocol
    
    init(transport: any TransportSessionProtocol) {
        self.transport = transport
        self.password = generatePassword()
    }
    
    private func generatePassword(length: Int = 4) -> [String] {
        let charset = (1...8).map { String($0) }
        return (0..<length).compactMap { _ in charset.randomElement() }
    }
}
