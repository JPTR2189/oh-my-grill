
//
//  NewGameViewModelProtocol.swift
//  poc-CoreMotiob
//
//  Created by Maria Santellano on 19/11/25.
//

import Foundation

protocol NewGameViewModelProtocol {
    var username: String { get set }
    var transport: TransportSessionProtocol? { get set }
    
    func clearTextfield()
}
