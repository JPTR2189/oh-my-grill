//
//  RoundInfo.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 25/11/25.
//

import SwiftUI

struct RoundInfo: View {
    //let round: Round
    
    var body: some View {
        HStack(spacing: 0) {
            
            //Text("\(Int(round.time))")
            Text("00:00")
                .font(.custom("Poppins", size: 17))
                .foregroundStyle(.texasBeige)
                .padding(.horizontal)
                .padding(.vertical, 13)
                .background(
                    RoundedCorners(radius: 12, corners: [.topLeft, .bottomLeft])
                        .foregroundStyle(.texasCherry)
                        .shadow(color: .texasBrown, radius: 0.5, x: 0, y: 7)
                )

            
            VStack(alignment: .center, spacing: 8) {
                Text("Round")
                    .font(.custom("Poppins", size: 16))
                    .foregroundStyle(.texasBeige)
                //Text("\(round.number)")
                Text("2")
                    .font(.custom("Toy Block Maestro", size: 60))
                    .foregroundStyle(.texasBeige)
            }
            .padding(.horizontal)
            .padding(.vertical, 13)
            .frame(width: 100, height: 104)
            .background(
                RoundedCorners(radius: 12, corners: [.bottomRight, .bottomLeft])
                    .foregroundStyle(.accent)
                    .shadow(color: .texasBrown, radius: 0.5, x: 0, y: 7)
            )
        }
    }
}

#Preview {
    RoundInfo()
}
