//
//  SettingsView.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 09/12/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        
        ZStack {
            
            //MARK: Background
            Image(.backgroundOut)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            BackButtonComponent()
                .padding(.top)
            
            // (TITLE | BUTTONS)
            VStack(spacing: 32){
                
                // (TITLE)
                VStack(spacing: 8){
                    Text("SETTINGS")
                        .font(.custom("TOY BLOCK MAESTRO", size: 56))
                        .foregroundStyle(.texasBlack)
                    
                    Text("Customize the game to your liking for the best experience.")
                        .frame(width: 258)
                        .font(.custom("Poppins", size: 15))
                        .foregroundStyle(.texasBlack)
                        .multilineTextAlignment(.center)
                    
                }
                
                // (BUTTONS)
                HStack(spacing: 40){
                    SettingsComponent(type: .music)
                    SettingsComponent(type: .haptics)
                }
            }
            

            
        }
    }
}

#Preview {
    SettingsView()
}
