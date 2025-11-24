//
//  JoinViewController.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 21/11/25.
//

import Foundation

class JoinViewController: JoinViewControllerProtocol {
    let transport: any TransportSessionProtocol
    
    init(transport: any TransportSessionProtocol) {
        self.transport = transport
    }
}
