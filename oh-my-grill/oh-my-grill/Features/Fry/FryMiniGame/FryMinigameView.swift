//
//  FryView.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 05/12/25.
//

import SwiftUI

struct FryMinigameView: View {
    
    @State var viewModel: any FryMinigameViewModelProtocol
        
    var body: some View {
        ZStack{
            
            Image(.backgroundMiniGame)
                .resizable()
                .ignoresSafeArea()
            
            
            // (ROUND)
            VStack{
                HStack(alignment: .top, spacing: 0){
                    Spacer()
                    
                    if let round =  viewModel.session.currentRound {
                        RoundNumber(round: round)
                    }
                    
                }
                .offset(x: 55 ,y: 2)
                
                Spacer()
            }
            
            // (TITLE | IMAGE | PROGRESS BAR)
            VStack(spacing: 0) {
                
                // (TITLE | IMAGE)
                VStack(spacing: 0){
                    
                    // (TITLE)
                    VStack(spacing: 8){
                        Text("FRY THE POTATOES")
                            .font(.custom("Toy Block Maestro", size: 56))
                            .foregroundStyle(.texasBeige)
                        
                        Text("Tilt your phone and fry the potatoes, being careful not to burn them.")
                            .font(.custom("Poppins", size: 15))
                            .foregroundStyle(.texasBeige)
                        
                    }
                    
                    Image(.potatoBase)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 428, height: 208)
                    
                    
                }
                
                Spacer()
                
                // SENSOR MARKER
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 400, height: 30)
                            .foregroundStyle(.texasBeige)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.texasGreen)
                                    .frame(width: 54, height: 30)
                                    .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                                        .foregroundStyle(.texasBrown)
                                        .foregroundStyle(.gray)
                                    )
                        )
                        
                        // RECTANGLE SHADOW
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 400, height: 30)
                                    .foregroundStyle(.texasBrown)
                                    .offset(y: 8)
                            )
                        
                        // MARKER
                        Rectangle()
                            .frame(width: 4, height: 30)
                            .foregroundStyle(.texasBrown)
                    }
                
                    
            }
            .padding(.top, 24)
                
            
            
            
            
        }
        
    }
        
}

#Preview {
    FryMinigameView(viewModel: FryMinigameViewModel(session: GameSession(transport: TransportSession(userName: "Teste"), config: GameConfigPayload(mode: .chaos, players: [""], roles: ["":.chef]))))
}
