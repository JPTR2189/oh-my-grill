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
    private var service: OrdersService = OrdersService()
    

    init(session: GameSession) {
        self.session = session
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
}

extension ChefViewModel: OrdersServiceDelegateProtocol {
    func updateOrders(_ orders: [Order], _ moreOrders: Int) {
        self.orders = orders
        self.moreOrders = moreOrders
    }
    
  
        
    
    
}

