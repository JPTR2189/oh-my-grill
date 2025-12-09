//
//  OrdersServiceDelegateProtocol.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 03/12/25.
//

import Foundation

protocol OrdersServiceDelegateProtocol {
    func updateOrders(_ orders: [Order], _ moreOrders: Int);    
}
