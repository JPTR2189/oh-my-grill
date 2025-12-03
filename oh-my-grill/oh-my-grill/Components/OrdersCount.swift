//
//  OrdersCount.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 03/12/25.
//

import SwiftUI

struct OrdersCount: View {
    let quantity: Int
    
    var body: some View {
        Text("\(quantity)+")
            .font(.custom("Toy Block Maestro", size: 32).weight(.semibold))
            .foregroundStyle(.texasBeige)
            .padding(.vertical, 13)
            .frame(width: 85, height: 50)
            .background(
                RoundedCorners(radius: 12, corners: [.topRight, .bottomRight])
                    .foregroundStyle(.texasCherry)
                    .shadow(color: .texasBrown, radius: 0.5, x: 0, y: 7)
            )
    }
}

#Preview {
    OrdersCount(quantity: 3)
}
