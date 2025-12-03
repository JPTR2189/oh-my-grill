//
//  GrillView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 02/12/25.
//

import SwiftUI

struct GrillView: View {
    
    @Bindable var vm: GrillViewModel
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Image(.backgroundMiniGame)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                if let round = vm.round {
                    RoundNumber(round: round)
                        .padding(.top, 0)
                        .padding(.trailing, 0)
                }
                
                Image(.grill)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 620, height: 320)
                    .padding(.top, 36)
                    .padding(.trailing, 110)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.top, 0)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    GrillView()
//}
