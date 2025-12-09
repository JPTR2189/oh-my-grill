//
//  FryView.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 05/12/25.
//

import SwiftUI

struct FryMinigameView: View {
    
    @State var viewModel: any FryMinigameViewModelProtocol
    @Environment(\.dismiss) private var dismiss
    var ingredient: SKIngredient

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
                    
                    Image(viewModel.potatoIsFried ? .potatoCooked : .potatoBase)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 428, height: 208)
                }
                
                Spacer()
                
                // SENSOR MARKER
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: CGFloat(viewModel.sensorBarWidth), height: 30)
                        .foregroundStyle(viewModel.potatoIsFried ? .texasGreen : .texasBeige)
                        .overlay(
                            GeometryReader { proxy in
                                ZStack(alignment: .leading) {
                                    
                                    Color.clear
                                        .onAppear() {
                                            viewModel.updateSafeZoneOffset(size: proxy.size.width)
                                            viewModel.updateGreenZoneWidth(size: proxy.size.width)
                                            
                                            Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
                                                withAnimation(.linear(duration: 0.1)) {
                                                    
                                                    if viewModel.isCenter() {
                                                        viewModel.growGreenZone()
                                                    }
                                                }
                                            }
                                        }
                                    // GREEN ZONE
                                    HStack {
                                        Spacer()
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(viewModel.potatoIsFried ? .clear : viewModel.sensorColor.backgroundColor(for: viewModel.normalizedPosition))
                                            .frame(width: viewModel.greenZoneWidth, height: 30)
                                        //                                                .offset(x: viewModel.potatoIsFried ? -40 : 0)
                                        Spacer()
                                    }
                                    // BORER
                                    HStack {
                                        Spacer()
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                                            .foregroundStyle(.texasBrown)
                                            .frame(width: proxy.size.width * (0.57 - 0.45), height: 30)
                                        //                                            .offset(x: viewModel.safeZoneOffset)
                                        //                                                .animation(nil, value: viewModel.safeZoneOffset)
                                        Spacer()
                                    }
                                    
                                    // MARKER
                                    Rectangle()
                                        .frame(width: 4, height: 30)
                                        .foregroundStyle(.texasBrown)
                                        .offset(x: proxy.size.width * viewModel.normalizedPosition)
                                }
                            }
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 30)
                                .foregroundStyle(.texasBrown)
                                .offset(y: 8)
                        )
                }
            }
            .padding(.top, 24)
        }
        .onChange(of: viewModel.potatoIsFried) {
                ingredient.ingredient.cook()
                dismiss()
            }
        .onAppear {
            // Loop do Jogo
            Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
                withAnimation(.linear(duration: 0.1)) {
                    viewModel.updateMotion()
                }
            }
        }
        .onDisappear {
            viewModel.sensorController.stopMotionUpdates()
        }
    }
}

