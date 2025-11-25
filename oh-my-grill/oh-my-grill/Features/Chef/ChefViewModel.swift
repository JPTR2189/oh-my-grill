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
