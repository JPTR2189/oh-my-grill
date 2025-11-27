//
//  TestView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 24/11/25.
//

import SwiftUI

struct TestOrderView: View {
    var body: some View {
        Text("New order")
            .onAppear {
                let generator = OrderGenerator()
                let order = generator.generateOrder()

                print("NEW ORDER:")
                
//                for ingredient in order.meal.ingredients {
//                    print("- \(ingredient.type) [\(ingredient.state)]")
//                }
                
                print(order.meal.hasFries ? "fries" : "")
            }
    }
}

#Preview {
    TestOrderView()
}
