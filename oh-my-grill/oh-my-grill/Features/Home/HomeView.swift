//
//  HomeView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 18/11/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var start: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .center) {
                //MARK: Fundo
                Image(.backgroundOut)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
               
                //MARK: Conteúdo
                VStack(spacing: 25) {
                    Image(.logo)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 243)
                    
                    ButtonComponent (
                        buttonAction: {
                            start = true
                        },
                        text: String(localized: "Start Game")
                    )
                }
                .padding(.top, 30)
            }
            .onAppear {
                SoundManager.instance.playMusic(type: .menu)
            }
            .navigationDestination(isPresented: $start) {
                NewGameView(viewModel: NewGameViewModel())
            }
        }
    }
}

#Preview {
    HomeView()
}
