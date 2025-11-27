//
//  Ingredient.swift
//  poc-peerConnectivity
//
//  Created by João Pedro Teixeira de Carvalho on 14/11/25.
//

import Foundation

// Ingredient
public struct Ingredient: Codable, Hashable {
    public let type: IngredientType
    public var state: IngredientState
}

// Ingredient types - used to differentiate different ingredients
public enum IngredientType: String, Codable {
    case lettuce
    case tomato
    case bunTop
    case bunDown
    case burger
    case potato
    case cheese
    
    case genericParcel
}

// Ingredient state - used to manage different states from ingredients
public enum IngredientState: String, Codable {
    case base
    case sliced
    case cooked
    case burnt
    case cheesed
    case top
    case bottom
}


extension IngredientType {
    var displayName: String {
        switch self {
        case .lettuce: "Lettuce"
        case .tomato: "Tomato"
        case .bunTop: "BunTop"
        case .bunDown: "BunDown"
        case .burger: "Burger"
        case .potato: "Potato"
        case .cheese: "Cheese"
        case .genericParcel: ""
        }
    }
}
