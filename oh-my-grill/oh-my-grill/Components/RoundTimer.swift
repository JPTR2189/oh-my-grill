//
//  RoundTimer.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 02/12/25.
//

import SwiftUI

struct RoundTimer: View {
    let round: Round
    
    var body: some View {
        
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
    
    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}




#Preview {
    RoundTimer(round: Round(number: 1, minPoints: 1000))
}
