//
//  StationRole.swift
//  poc-peerConnectivity
//
//  Created by João Pedro Teixeira de Carvalho on 14/11/25.
//

import Foundation

public enum StationRole: String, Codable, CaseIterable {
    case chef
    case cuttingBoard
    case grill
    case fryer
    case notSet

    public var displayName: String {
        switch self {
        case .chef:          return "Chef"
        case .cuttingBoard:  return "Cutting"
        case .grill:         return "Grill"
        case .fryer:         return "Fryer"
        case .notSet:        return "Role not set"
        }
    }
    
    public init(from string: String) {
        if let match = StationRole.allCases.first(where: {
            $0.rawValue.lowercased() == string.lowercased()
        }) {
            self = match
            return
        }

        if let match = StationRole.allCases.first(where: {
            $0.displayName.lowercased() == string.lowercased()
        }) {
            self = match
            return
        }

        self = .notSet
    }
}
