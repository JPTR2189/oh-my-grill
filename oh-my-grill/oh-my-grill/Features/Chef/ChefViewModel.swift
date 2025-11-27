//
//  ChefViewModel.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 25/11/25.
//

import Foundation

@Observable
class ChefViewModel {
    var order: Order
    let generator = OrderGenerator()
    var statusTimer: Timer?
    
    init() {
        self.order = Order(meal: generator.generateOrder().meal)
        generateNewOrder()
        observeOrderStatus()
    }
    
    func getDataMock() -> Order {
        let pãoTopo = Ingredient(type: .bunTop, state: .top)
        let pãoBaixo = Ingredient(type: .bunDown, state: .bottom)
        let carne = Ingredient(type: .burger, state: .burnt)
        let tomate = Ingredient(type: .tomato, state: .sliced)
        let alface = Ingredient(type: .lettuce, state: .sliced)

        let ingredientesMock: [Ingredient: Int] = [
            pãoTopo: 1,
            pãoBaixo: 1,
            carne: 1,
            tomate: 2,
            alface: 1
        ]

        let mealTeste = Meal(imageName: "burger", ingredients: ingredientesMock)
        return Order(meal: mealTeste)


       
    }
 
    func generateNewOrder() {
        order.invalidateTimer()
        order = Order(meal: generator.generateOrder().meal)
    }

    private func observeOrderStatus() {
        statusTimer?.invalidate()

        statusTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            if self.order.status == .expired {
                self.generateNewOrder()
            }
        }
    }
}
