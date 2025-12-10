//
//  Order.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 24/11/25.
//

import Foundation

@Observable
public class Order: Identifiable {
    public let id: UUID
    public let meal: Meal
    public var time: TimeInterval
    public var status: OrderStatus {
        didSet { onStatusChanged?(self) }
    }
    
    public var onStatusChanged: ((Order) -> Void)?
    
    public let points: Int
    
    private var timer: Timer?

    public init(meal: Meal) {
        self.id = UUID()
        self.meal = meal
        self.time = 30
        self.points = 50
        self.status = .waiting
        startCountdown()
    }

    public func startCountdown() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            if self.time > 0 {
                self.time -= 1
            } else {
                self.time = 0
                self.status = .expired
                self.timer?.invalidate()
            }
        }
    }

    public func invalidateTimer() {
        timer?.invalidate()
    }
    
    public var getTime: Int {
        Int(time)
    }
}


public enum OrderStatus: String, Codable {
    case waiting
    case delivered
    case expired
}
