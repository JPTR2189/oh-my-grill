//
//  ChefViewModel.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 25/11/25.
//

import Foundation

@Observable
class ChefViewModel {
    let session: GameSession
    var orders: [Order]
    var moreOrders: Int = 0
    var gameIsRunning = false
    
    private var delegate: OrdersServiceDelegateProtocol?
    var service: OrdersService


    init(session: GameSession) {
        self.session = session
        self.service = OrdersService(session: session)
        self.orders = []
        self.service.delegate = self
    }


    var round: Round? {
        session.currentRound
    }
    
    func startGame() {
        self.service.startTimer()
        self.service.addOrder()
    }
    
    public func check(_ burger: SKBurger) -> Bool {
        
        var hasMatch = false
        
        print("\n\nChecking burger order")
        for order in service.orders {
            let orderIngredients = order.meal.ingredients.sorted { $0.type.rawValue < $1.type.rawValue }.map { $0.type.rawValue }
            let burgerIngredients = burger.stack.sorted { $0.ingredient.type.rawValue < $1.ingredient.type.rawValue }.map { $0.ingredient.type.rawValue }
            
            print("Order: \(orderIngredients)")
            print("Burger: \(burgerIngredients)")
            
            if orderIngredients.count != burgerIngredients.count { continue }
            
            hasMatch = true
            for i in 0..<orderIngredients.count {
                if orderIngredients[i] != burgerIngredients[i] { hasMatch = false; break }
            }
            
            if hasMatch {
                service.popOrder(order)
                session.currentRound?.points += 10
                break
            }
        }
        return hasMatch
    }
}

extension ChefViewModel: OrdersServiceDelegateProtocol {
    func updateOrders(_ orders: [Order], _ moreOrders: Int) {
        self.orders = orders
        self.moreOrders = moreOrders
    }
}
