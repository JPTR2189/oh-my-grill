//
//  OrderGenerator.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 24/11/25.
//

import Foundation

final class OrderGenerator {

    func generateOrder() -> Order {
        let meal = generateMeal()
        return Order(meal: meal)
    }

    private func generateMeal() -> Meal {
        let ingredients = generateIngredients()
        let hasFries = false
        return Meal(ingredients: ingredients, hasFries: hasFries)
    }

    private func generateIngredients() -> [Ingredient] {

        // 1. Primeiro ingrediente: bun-top
        let topBun = Ingredient(type: .topBun, state: .base)

        // 2. Ultimo ingrediente: bun-bottom
        let bottomBun = Ingredient(type: .bottomBun, state: .base)

        // 3. Penúltimo ingrediente: burger-cheesed
        let cheesedBurger = Ingredient(type: .burger, state: .cheesed)

        
        let middleOptions: [Ingredient] = [
            Ingredient(type: .tomato, state: .sliced),
            Ingredient(type: .lettuce, state: .sliced),
        ]

        let middleCount = Int.random(in: 0...3)

        var middleIngredients: [Ingredient] = []
        for _ in 0..<middleCount {
            if let random = middleOptions.randomElement() {
                middleIngredients.append(random)
            }
        }

        var result: [Ingredient] = []
        result.append(topBun)
        result.append(contentsOf: middleIngredients)
        result.append(cheesedBurger)
        result.append(bottomBun)

        return result
    }
}
