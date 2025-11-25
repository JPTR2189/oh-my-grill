//
//  Order.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 24/11/25.
//

import Foundation

public struct Order: Codable, Identifiable {
    public let id: UUID
    public let meal: Meal
    public let time: TimeInterval
    public let points: Int
    public var status: OrderStatus
    
    public init(meal: Meal) {
        self.id = UUID()
        self.meal = meal
        self.time = 60
        self.points = 50
        self.status = .waiting
    }
}

public enum OrderStatus: String, Codable {
    case waiting
    case delivered
    case expired
}
