//
//  GrillMiniGameView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 02/12/25.
//

import SwiftUI

struct GrillMiniGameView: View {
    @Bindable var vm: GrillMiniGameViewModel
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Image(.backgroundMiniGame)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                if let round = vm.round {
                    RoundNumber(round: round)
                        .padding(.top, 8)
                        .padding(.trailing, 0)
                }
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Grill the meat")
                            .font(.custom("Toy Block Maestro", size: 56))
                            .padding(.horizontal, 157)
                        
                        Text("Flip your phone to cook your meat.")
                            .font(.custom("Poppins Regular", size: 15))
                    }
                    .foregroundStyle(.texasBeige)
                    
                    Image(vm.didRotate360 ? "burger-cooked" : "burger-base")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                        .animation(.easeIn, value: vm.didRotate360)
                    }
                .padding(.top, 32)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $vm.nextView) {
                GrillView()
            }
        }
    }
}


//#Preview {
//    GrillMiniGameView()
//}
