//
//  OrderCard.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 25/11/25.
//

import SwiftUI

struct OrderCard: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(
                order.meal.ingredients
                    .map { $0.type.displayName }
                    .joined(separator: ", ")
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            Text("Time: \(Int(order.time))s")
                .font(.caption)
            Text("Status: \(order.status.rawValue)")
                .foregroundColor(order.status == .expired ? .red : .green)
                .font(.caption)
        }
        .padding()
        .frame(width: 200, height: 200)
        .background(.texasBeige)
        .cornerRadius(12)
    }
}
