//
//  Meal.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 24/11/25.
//

import Foundation

public struct Meal: Codable, Identifiable {
    public var id = UUID()          
    public let imageName: String
    public let ingredients: [Ingredient: Int]
    public let hasFries: Bool
    
    
        public init(imageName: String, ingredients: [Ingredient: Int]) {
            self.imageName = imageName
            self.ingredients = ingredients
            self.hasFries = true
        }
}
