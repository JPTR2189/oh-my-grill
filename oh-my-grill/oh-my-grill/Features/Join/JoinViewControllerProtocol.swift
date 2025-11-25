//
//  JoinViewControllerProtocol.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 21/11/25.
//

import Foundation
import SwiftUI

protocol JoinViewControllerProtocol {
    var transport: any TransportSessionProtocol { get }
    var password: [String] { get }
    var rawPassword: String { get }
    
    func insertToPassword(_ char: String)
    func removeFromPassword()
    
    func tryToJoin(withPassword password: String)
}
