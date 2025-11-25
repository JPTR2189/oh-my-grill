//
//  JoinViewController.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 21/11/25.
//

import Foundation
import SwiftUI

@Observable
class JoinViewController: JoinViewControllerProtocol {
    
    init(transport: any TransportSessionProtocol) {
        self.transport = transport
    }

    let transport: any TransportSessionProtocol
    var password: [String] = []
    
    var rawPassword: String {
        password.joined()
    }

    func insertToPassword(_ char: String) {
        if password.count < transport.passwordLength {
            password.append(char)
        }
    }

    func removeFromPassword() {
        if password.count == 0 { return }
        password.removeLast()
    }

    func tryToJoin(withPassword password: String) {
        transport.tryToJoin(withPassword: password)
    }
}
