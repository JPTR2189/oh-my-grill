//
//  AssignCardComponent.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 25/11/25.
//

import SwiftUI

struct AssignCardComponent: View {
    var name: String?
    var station: String
    
    var body: some View {
        ZStack {
            VStack {
                Text(name ?? "")
                    .font(.custom("Toy Block Maestro", size: 32))
                    .foregroundStyle(.texasBlack)
                    .frame(width: 80, height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.texasBeige)
                    )
                
                Text(station)
                    .font(.custom("Toy Block Maestro", size: 23))
                    .foregroundStyle(.white)
                    .padding(.top, 6)
                    .padding(.bottom, 16)
            }
            .padding(.top, 16)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.texasCherry)
                    .shadow(
                        color: .texasBrown,
                        radius: 0.5,
                        x: 0,
                        y: 7
                    )
            )
        }
    }
}
