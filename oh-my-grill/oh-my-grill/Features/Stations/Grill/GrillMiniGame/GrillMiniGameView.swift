//
//  GrillMiniGameView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 02/12/25.
//

import SwiftUI

struct GrillMiniGameView: View {
    
    @Bindable var vm: GrillMiniGameViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Image(.backgroundMiniGame)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                if let round = vm.round {
                    RoundNumber(round: round)
                }
                
                VStack(alignment: .center, spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Grill the meat")
                            .font(.custom("Toy Block Maestro", size: 56))
                        
                        Text("Rotate your phone to cook your meat.")
                            .font(.custom("Poppins Regular", size: 15))
                    }
                    .foregroundStyle(.texasBeige)
                    .padding(.trailing, 170)
                    
                    Image(vm.didRotate360 ? "burger-cooked" : "burger-base")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                        .animation(.easeIn, value: vm.didRotate360)
                        .padding(.trailing, 185)
                }
                .padding(.top, 32)
            }
            .navigationBarBackButtonHidden(true)
            .onChange(of: vm.didRotate360) {
                vm.ingredient.ingredient.cook()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    dismiss()
                }
            }
            
            // MARK: Navigation
            .navigationDestination(
                isPresented: Binding(
                    get: { vm.session.finishedRound != nil },
                    set: { _ in vm.session.finishedRound = nil }
                )
            ) {
                if let round = vm.session.finishedRound {
                    FeedbackView(round: round)
                }
            }
        }
    }
}
