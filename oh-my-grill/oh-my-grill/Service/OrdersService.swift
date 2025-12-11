//
//  OrdersService.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 03/12/25.
//

import Foundation

class OrdersService {
    
    private var previousRound: Int = 1
    private var timer: Timer?
    private var secondsToSpawn: Int = 0
    private var spawnInterval: Int = 10
    var delegate: OrdersServiceDelegateProtocol?
    private let generator: OrderGenerator = OrderGenerator()
    private var moreOrders: Int = 0
    var session: GameSession
    


    var orders: [Order] = []
    
    var currentRound: Int {
        session.getRoundNumber
    }

    
    init(session: GameSession) {
        self.session = session
    }
    
    func startTimer() {
        secondsToSpawn = 0
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true,) {[weak self] _ in
        
            guard let self else { return }
            
           
            
            self.secondsToSpawn += 1
            
            if self.secondsToSpawn >= spawnInterval {
                stopTimer()
                startTimer()
                
                addOrder()
                

            }
  
            
        // Diminui o tempo de spawn a cada intervalo
        if previousRound != currentRound {
            
            if spawnInterval > 4 && previousRound > 1{
                
                spawnInterval = max(4, spawnInterval - 2)
                
            }
            
            previousRound = currentRound
        }
        
      
        }
        
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func addOrder() {
        DispatchQueue.main.async {
            let newOrder = Order(meal: self.generator.generateOrder().meal)
            
            newOrder.onStatusChanged = {[weak self] order in
                self?.removeExpiredOrder(for: order)
            }
            
            if self.orders.count < 3 {
                self.orders.append(newOrder)
            }
            else {
                self.moreOrders += 1
            }
            

            self.updateOrders(orders: self.orders, moreOrders: self.moreOrders)
        }

    }
    
    func updateOrders(orders: [Order], moreOrders: Int) {
        delegate?.updateOrders(orders, moreOrders)
        
    }
    
    func clearOrdersList() {
        orders.removeAll()
    }
    
    func removeExpiredOrder(for order: Order) {
        if order.status == .expired {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.orders.removeAll(where: {$0.id == order.id})
                
                if self.moreOrders > 0 && self.orders.count < 3 { self.addOrder(); self.moreOrders -= 1}

                self.updateOrders(orders: self.orders, moreOrders: self.moreOrders)
            }
            
            
        }
    }
    
    public func popOrder(_ order: Order) {
        orders.removeAll(where: { $0.id == order.id })
    }
    
}


