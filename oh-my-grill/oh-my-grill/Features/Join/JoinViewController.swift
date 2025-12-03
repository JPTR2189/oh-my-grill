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
    var wrongPassword: Bool = false
    
    var rawPassword: String {
        password.joined()
    }

    func insertToPassword(_ char: String) {
        if password.count < transport.passwordLength {
            password.append(char)
        }
        wrongPassword = false
    }

    func removeFromPassword() {
        if password.count == 0 { return }
        password.removeLast()
        wrongPassword = false
    }

    func tryToJoin(withPassword password: String) {
        wrongPassword = false
        transport.tryToJoin(withPassword: password)
    }
}
