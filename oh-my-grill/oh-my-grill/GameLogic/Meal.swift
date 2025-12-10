//
//  Meal.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 24/11/25.
//

import Foundation

public struct Meal: Codable, Identifiable {
    public let id: UUID
    public var ingredients: [Ingredient]
    public var hasFries: Bool
    
    public init(ingredients: [Ingredient], hasFries: Bool) {
        self.id = UUID()
        self.ingredients = ingredients
        self.hasFries = hasFries
    }
}
