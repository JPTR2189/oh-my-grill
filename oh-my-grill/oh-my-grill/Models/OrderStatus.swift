//
//  OrderStatus.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 26/11/25.
//

import Foundation
public enum OrderStatus: String, Codable {
    case waiting
    case delivered
    case expired
}
