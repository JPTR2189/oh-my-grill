//
//  RoundNumber.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 27/11/25.
//

import SwiftUI

struct RoundNumber: View {
    let round: Round

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Round")
                .font(.custom("Poppins", size: 16))
                .foregroundStyle(.texasBeige)
            Text("\(round.number)")
                .font(.custom("Toy Block Maestro", size: 60))
                .foregroundStyle(.texasBeige)
        }
        .padding(.horizontal)
        .padding(.vertical, 13)
        .frame(width: 115, height: 104)
        .background(
            RoundedCorners(radius: 12, corners: [.bottomRight, .bottomLeft])
                .foregroundStyle(.accent)
                .shadow(color: .texasBrown, radius: 0.5, x: 0, y: 7)
        )

    }
}

#Preview {
    RoundNumber(round: Round(number: 1, minPoints: 1000))
}
