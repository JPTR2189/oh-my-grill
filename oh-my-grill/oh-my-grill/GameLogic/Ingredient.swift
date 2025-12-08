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
    
    static func getRandom() -> Ingredient {
        while true {
            let ingredient = Ingredient(type: IngredientType.getRandom(), state: .base)
            
            if ingredient.type != .genericParcel { return ingredient }
        }
    }
    
    var imageName: String {
        if type == .bottomBun || type == .topBun { return type.imageName }

        let preffix: String = type.rawValue
        let suffix: String = state.rawValue        
        
        return "\(preffix)-\(suffix)"
    }
    
    mutating func cut() {
        print("\(type.displayName) cutted!")
        self.state = .sliced
    }
    
    mutating func cook() {
        print("\(type.displayName) cooked!")
        self.state = .cooked
    }
}

// Ingredient types - used to differentiate different ingredients
public enum IngredientType: String, Codable, CaseIterable {
    case lettuce
    case tomato
    case topBun
    case bottomBun
    case burger
    case potato
    case cheese
    
    case genericParcel
}

extension IngredientType {
    var displayName: String {
        switch self {
        case .lettuce: "Lettuce"
        case .tomato: "Tomato"
        case .topBun: "Top Bun"
        case .bottomBun: "Bottom Bun"
        case .burger: "Burger"
        case .potato: "Potato"
        case .cheese: "Cheese"
        case .genericParcel: "Generic"
        }
    }

    var imageName: String {
        switch self {
        case .lettuce: "lettuce-sliced"
        case .tomato: "tomato-sliced"
        case .topBun: "bun-top"
        case .bottomBun: "bun-bottom"
        case .burger: "burger-cheesed"
        case .potato: "potato"
        case .cheese: "cheese-base"
        case .genericParcel: "parcel"
        }
    }
    
    static func getRandom() -> IngredientType {
        IngredientType.allCases.randomElement() ?? .burger
    }
}

// Ingredient state - used to manage different states from ingredients
public enum IngredientState: String, Codable {
    case base
    case sliced
    case cooked
    case burnt
    case cheesed
}
