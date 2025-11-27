//
//  Ingredient.swift
//  poc-peerConnectivity
//
//  Created by João Pedro Teixeira de Carvalho on 14/11/25.
//

import Foundation

// Ingredient
public struct Ingredient: Codable {
    public let type: IngredientType
    public var state: IngredientState
}

// Ingredient types - used to differentiate different ingredients
public enum IngredientType: String, Codable {
    case lettuce
    case tomato
    case bun
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
        case .bun: "Bun"
        case .burger: "Burger"
        case .potato: "Potato"
        case .cheese: "Cheese"
        case .genericParcel: ""
        }
    }
}


extension IngredientType {
    var imageName: String {
        switch self {
        case .lettuce: "lettuce-sliced"
        case .tomato: "tomato-sliced"
        case .bun: "bun-top"
        case .burger: "burger-cheesed"
        case .potato: "potato"
        case .cheese: "cheese-base"
        case .genericParcel: "parcel"
        }
    }
}
