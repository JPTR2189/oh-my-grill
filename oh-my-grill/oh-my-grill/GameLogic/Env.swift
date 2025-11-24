//
//  Env.swift
//  poc-peerConnectivity
//
//  Created by João Pedro Teixeira de Carvalho on 24/11/25.
//

import Foundation

// Different game modes
public enum GameMode: String, Codable, Equatable {
    case classic
    case chaos
}

// Represents a part of the screen - used to send parcels via MP
public enum EdgeSide: String, Codable {
    case left
    case right
    case none
}
