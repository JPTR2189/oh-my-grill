//
//  HostViewController.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 21/11/25.
//

import Foundation

final class HostViewController: HostViewControllerProtocol {
    var password: [String] = []
    var rawPassword: String {
        password.joined()
    }
    
    let transport: any TransportSessionProtocol
    var passwordLength: Int
    
    init(transport: any TransportSessionProtocol) {
        self.transport = transport
        self.passwordLength = transport.passwordLength
        self.password = generatePassword(length: passwordLength)
    }
    
    private func generatePassword(length: Int) -> [String] {
        let charset = (1...8).map { String($0) }
        return (0..<length).compactMap { _ in charset.randomElement() }
    }
}
