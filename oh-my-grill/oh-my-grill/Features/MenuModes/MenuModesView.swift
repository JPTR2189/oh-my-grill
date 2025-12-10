//
//  MenuModes.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 10/12/25.
//

import SwiftUI

struct MenuModesView: View {
    @State private var start: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                // Background
                Image(.backgroundOut)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                BackButtonComponent()
                
                VStack(spacing: 21) {
                    VStack(spacing: 8) {
                        Text("MODE")
                            .font(.custom("Toy Block Maestro", size: 55))
                        Text("Choose your game mode.")
                            .font(.custom("Poppins Regular", size: 15))
                            .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.texasBlack)
                    
                    HStack(spacing: 21) {
                        Button {
                            
                        } label: {
                            ModeButton(image: Image("normalStar"), mode: "Normal")
                        }
                        
                        Button {
                            
                        } label: {
                            ModeButton(image: Image("caotic"), mode: "Caos")
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 25)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $start) {
                NewGameView(viewModel: NewGameViewModel())
            }
        }
    }
}
