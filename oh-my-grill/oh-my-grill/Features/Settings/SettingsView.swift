//
//  SettingsView.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 09/12/25.
//

import SwiftUI

struct SettingsView: View {
    
    // SAVE MUSIC STATE
    @AppStorage("isMusicOn") var isMusicOn: Bool = true
    
    // SAVE HAPTICS STATE
    @AppStorage("isHapticsOn") var isHapticsOn: Bool = true

    
    
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
                    Button(action: {
                        
                        isMusicOn.toggle()
                        
                        SoundManager.instance.toogleMusic(isOn: isMusicOn, musicType: .game)
                        SoundManager.instance.toogleMusic(isOn: isMusicOn, musicType: .menu)
                        
                        
                        HapticManager.instance.notification(type: .success)
                        
                        
                    }) {
                        SettingsComponent(type: .music, active: isMusicOn)
                        
                            
                    }
                    
                    Button(action: {
                        
                        isHapticsOn.toggle()
                        
                        if isHapticsOn {
                            HapticManager.instance.notification(type: .success)
                        }
                        
                    }) {
                        SettingsComponent(type: .haptics, active: isHapticsOn)
                            
                            
                    }
                }
            }
            

            
        }
    }
}

#Preview {
    SettingsView()
}
