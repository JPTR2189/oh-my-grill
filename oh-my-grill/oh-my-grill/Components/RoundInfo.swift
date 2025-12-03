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
            
            RoundTimer(round: round)


            
            RoundNumber(round: round)
        }
    }
}

#Preview {
    RoundInfo(round: Round(number: 1, minPoints: 100))
}
