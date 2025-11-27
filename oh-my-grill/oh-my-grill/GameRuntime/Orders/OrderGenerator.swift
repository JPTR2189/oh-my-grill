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
        let hasFries = true
        return Meal(imageName: "burger", ingredients: ingredients)
    }

    private func generateIngredients() -> [Ingredient: Int] {
        
        // Ingredientes fixos
        let topBun = Ingredient(type: .bunTop, state: .top)
        let bottomBun = Ingredient(type: .bunDown, state: .bottom)
        let cheesedBurger = Ingredient(type: .burger, state: .cheesed)
        
        // Todos os fixos possuem apenas uma unidade
        var ingredientsCount: [Ingredient: Int] = [
            topBun: 1,
            bottomBun: 1,
            cheesedBurger: 1
        ]
        
        // Ingredientes adicionais
        let middleOptions: [Ingredient] = [
            Ingredient(type: .tomato, state: .sliced),
            Ingredient(type: .lettuce, state: .sliced),
        ]
        
        // Sorteamos a quantidade de recheios extras
        let middleCount = Int.random(in: 0...3)
        
        for _ in 0..<middleCount {
            if let randomIngredient = middleOptions.randomElement() {
                // Se o ingrediente já existe, soma +1. Se não, começa com 0 e soma 1.
                ingredientsCount[randomIngredient, default: 0] += 1
            }
        }
        
        return ingredientsCount
    }
}

