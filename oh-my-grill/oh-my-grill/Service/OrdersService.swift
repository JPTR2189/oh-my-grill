//
//  OrdersService.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 03/12/25.
//

import Foundation

class OrdersService {
    
    private var timer: Timer?
    private var secondsToSpawn: Int = 0
    var delegate: OrdersServiceDelegateProtocol?
    private let generator: OrderGenerator = OrderGenerator()
    private var moreOrders: Int = 0

    var orders: [Order] = []
    
    func startTimer() {
        secondsToSpawn = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true,) {[weak self] _ in
        
            guard let self else { return }
            
            self.secondsToSpawn += 1
            
            if self.secondsToSpawn == 10{
                stopTimer()
                startTimer()
                
                addOrder()
                

            }
  
        }
        
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
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


