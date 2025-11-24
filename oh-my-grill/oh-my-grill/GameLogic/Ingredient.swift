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
    case bread
    case patty
    case potato
    
    case genericParcel
}

// Ingredient state - used to manage different states from ingredients
public enum IngredientState: String, Codable {
    case base
    case chopped
    case cooked
    case burnt
}
