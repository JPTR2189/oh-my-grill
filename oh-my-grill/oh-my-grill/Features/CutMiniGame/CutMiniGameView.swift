//
//  CutMiniGameView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 25/11/25.
//

import SwiftUI

struct CutMiniGameView: View {
    @State var viewModel: any CutMiniGameViewModelProtocol

    var body: some View {
        ZStack {
            (viewModel.gestureComplete ?
                Color.green.opacity(1.0) :
                Color.gray.opacity(0.8))
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut, value: viewModel.gestureComplete)
            
            Image(viewModel.gestureComplete ? "tomato-sliced" : "tomato-base")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .animation(.easeInOut, value: viewModel.gestureComplete)
                .padding(.bottom, 50) 
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack {
                        Text("Progresso: \(viewModel.gestureCount) / \(viewModel.requiredGestures)")
                             .font(.custom("Toy Block Maestro", size: 20))
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        ProgressView(value: viewModel.progressAmount)
                            .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                            .scaleEffect(x: 1, y: 5)
                            .padding(.horizontal, 40)
                            .animation(.linear(duration: 0.3), value: viewModel.progressAmount)
                    }
                    .padding(.vertical)
                    
                    
                    if viewModel.gestureComplete {
                        Button("Recomeçar Gesto") {
                            viewModel.resetGesture()
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding([.horizontal, .top], 40)
                        .transition(.opacity)
                    }
                }
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            }
        }
    }
}
