//
//  RoundInfo.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 25/11/25.
//

import SwiftUI

struct RoundInfo: View {
    let round: Round
    
    var body: some View {
        HStack(spacing: 0) {
            
            Text("\(formatTime(round.time))")
                .font(.custom("Poppins", size: 17).weight(.semibold))
                .foregroundStyle(.texasBeige)
                .padding(.horizontal)
                .padding(.vertical, 13)
                .frame(width: 85)
                .background(
                    RoundedCorners(radius: 12, corners:  [.topLeft, .bottomLeft])
                        .foregroundStyle(.texasCherry)
                        .shadow(color: .texasBrown, radius: 0.5, x: 0, y: 5)
                )
                
            
            
            
        }

            
            RoundNumber(round: round)
        }
    
    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

  



#Preview {
    RoundInfo(round: Round(number: 1, minPoints: 100))
}
