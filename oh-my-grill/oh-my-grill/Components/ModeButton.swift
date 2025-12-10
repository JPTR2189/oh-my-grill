//
//  ModeButton.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 10/12/25.
//

import SwiftUI

struct ModeButton: View {
    var image: Image
    var mode: String
    
    var body: some View {
        ZStack {
            VStack {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.texasBeige)
                    )
                
                Text(mode)
                    .font(.custom("Poppins Bold", size: 23))
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
