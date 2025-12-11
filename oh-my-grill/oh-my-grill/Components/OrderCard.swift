//
//  OrderCard.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 25/11/25.
//

import SwiftUI

struct OrderCard: View {
    let order: Order
    
    private let allowedTypes: [IngredientType] = [
        .burger, .tomato, .lettuce
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Cabeçalho: Nome + imagem do combo
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Combo")
                        .font(.custom("Poppins Regular", size: 16))
                        .foregroundColor(.texasBrown)
                    
                    Text(formatTime(order.time))
                        .font(.custom("Poppins SemiBold", size: 20))
                        .foregroundColor(.texasBrown)
                }
                .padding(.leading, 24)
                .padding(.top, 8)
                
                Spacer()
                
                Image("burger-complete")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding([.leading, .trailing] ,8)
            }
            
            // GRID DE INGREDIENTES
            HStack(spacing: 12) {   // ajuste o spacing como quiser
                
                ForEach(allowedTypes, id: \.self) { type in
                    let count = groupedIngredients[type]?.count ?? 0
                    
                    VStack(spacing: 2) { // mais coladinho
                        
                        if allowedTypes == [.burger] {
                            Image("\(type.rawValue)-cheesed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        } else {
                            Image("\(type.rawValue)-sliced")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22) // menor para caber numa linha
                        }
                        
                        Text("\(count)x")
                            .font(.custom("Poppins Regular", size: 16))
                            .foregroundColor(.texasBrown)
                    }
                }
                
                // FRIES
                if order.meal.hasFries {
                    VStack(spacing: 2) {
                        Image(.potatoCooked) // nome correto aqui
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                        
                        Text("1x")
                            .font(.custom("Poppins Regular", size: 16))
                            .foregroundColor(.texasBrown)
                    }
                    .padding(.bottom, 2)
                }
            }
            .padding([.leading, .trailing], 16)
            
            
        }
        .frame(width: 165, height: 120)
        .background(
            RoundedCorners(radius: 12, corners: [.bottomRight, .bottomLeft])
                .foregroundStyle(.texasSalmon)
                .shadow(color: .texasBrown, radius: 0.5, x: 0, y: 7)
        )
        .opacity(order.status == .expired ? 0.7 : 1)
    }
    
    
    // MARK: Helpers
    
    private var groupedIngredients: [IngredientType: [Ingredient]] {
        let filtered = order.meal.ingredients.filter { allowedTypes.contains($0.type) }
        return Dictionary(grouping: filtered, by: { $0.type })
    }
    
    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
