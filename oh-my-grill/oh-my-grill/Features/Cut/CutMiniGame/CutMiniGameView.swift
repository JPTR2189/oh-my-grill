//
//  CutMiniGameView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 25/11/25.
//

import SwiftUI

struct CutMiniGameView: View {
    @State var vm: any CutMiniGameViewModelProtocol
    
    @State private var nextView: Bool = false
    
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
                        Text("Fast Cut")
                            .font(.custom("Toy Block Maestro", size: 56))
                        
                        Text("Make a cut moviment with your phone")
                            .font(.custom("Poppins Regular", size: 15))
                    }
                    .foregroundStyle(.texasBeige)
                    
                    Image(.knifeMiniGame)
                    
                    ProgressView(value: vm.progressAmount)
                        .progressViewStyle(CustomProgressCut())
                        .animation(.linear(duration: 0.3), value: vm.progressAmount)
                        .shadow(
                            color: .texasBrown,
                            radius: 0.5,
                            x: 0,
                            y: 7
                        )
                        .padding(.horizontal, 226)
                        .onChange(of: vm.gestureComplete) {
                                nextView = true
                            }
                    }
                .padding(.top, 32)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $nextView) {
                    CutView()
            }
        }
    }
}
