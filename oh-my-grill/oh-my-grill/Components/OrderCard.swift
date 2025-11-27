//
//  OrderCard.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 25/11/25.
//

import SwiftUI

struct OrderCard: View {
     @State var order: Order
    
    private let corFundo = Color(red: 0.96, green: 0.91, blue: 0.84)
    private let corTexto = Color(red: 0.35, green: 0.22, blue: 0.15)
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Texto e Ícone Principal
            HStack(alignment: .top) {
                VStack(alignment: .center, spacing: 5) {
                    Text(order.meal.imageName.capitalized)
                        .font(Font(UIFont(name: "Poppins-SemiBold", size: 24) ?? .systemFont(ofSize: 48)))
                        .foregroundColor(corTexto)
                        .monospacedDigit()
                    
                    // Contador
                    Text(formatarTempo(order.time))
                        .font(Font(UIFont(name: "Poppins-Bold", size: 40) ?? .systemFont(ofSize: 48)))
                        .foregroundColor(corTexto)
                        .monospacedDigit() // Mantém os números fixos sem tremer
                }
                
                Spacer()
                
                // ÍCONE PRINCIPAL
                Image(uiImage: UIImage(named: "burger")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    
                    
                    .clipShape(Circle())
            }
            
            // Lista de Ingredientes
            HStack(spacing: 0) {
                
                ForEach(order.meal.ingredients.sorted(by: { $0.key.type.rawValue > $1.key.type.rawValue }), id: \.key) { ingrediente, quantidade in
                    
                    VStack(spacing: 8) {
                        
                       
                        Image(iconeParaIngrediente(nome: ingrediente.type.rawValue))
                            .resizable()
                            .frame(width: 65, height: 65)
                            .aspectRatio(contentMode: .fit)
                            
                        
                        Text("\(quantidade)x")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(corTexto)
                    }
                }
            }
        }
        .padding(25)
        .frame(width: 300)
        .background(corFundo)
        .cornerRadius(20)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(corTexto)
                .offset(y: 12)
        )
        .opacity(order.status == .expired ? 0.5 : 1.0)
    }
    
    
    func formatarTempo(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func iconeParaIngrediente(nome: String) -> String {
        switch nome {
        case "tomato": return "tomato-sliced"
        case "lettuce": return "lettuce-sliced"
        case "cheese": return "cheese-base"
        case "bunTop": return "bun-top"
        case "bunDown": return "bun-bottom"
        case "burger" : return "burger-cooked"

        default: return "circle"
        }
    }
    
}

#Preview {
    
    
    let carne = Ingredient(type: .burger, state: .burnt)
    let tomate = Ingredient(type: .tomato, state: .sliced)
    let alface = Ingredient(type: .lettuce, state: .sliced)

    let ingredientesMock: [Ingredient: Int] = [
        carne: 1,
        tomate: 2,
        alface: 1
    ]

    let mealTeste = Meal(imageName: "burger", ingredients: ingredientesMock)
    let orderTeste = Order(meal: mealTeste)


        OrderCard(order: orderTeste)
}


