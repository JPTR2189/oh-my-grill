//
//  PhysicsCategory.swift
//  poc-peerConnectivity
//
//  Created by João Pedro Teixeira de Carvalho on 10/11/25.
//

import Foundation

// Physics category - used to set the different hit categories
public struct PhysicsCategory {
    static let wall: UInt32 = 1 << 0
    static let parcel: UInt32 = 1 << 1
    static let gateWay: UInt32 = 1 << 2
    static let plate: UInt32 = 1 << 3
}
