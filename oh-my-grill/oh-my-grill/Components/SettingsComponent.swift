//
//  SettingsComponent.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 09/12/25.
//

import SwiftUI

struct SettingsComponent: View {
    
    let type: SettingsButtonType
    
    var body: some View {
        
        
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 18)
                .frame(width: 100, height: 90)
                .foregroundStyle(.accent)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .frame(width: 100, height: 90)
                        .foregroundStyle(.texasBrown)
                        .offset(y: 10)
                )
                .overlay(
                    type.image
                        .font(.system(size: 36))
                        
                )
            
            
            type.text
                .foregroundStyle(.white)
        }
        
    }
}

enum SettingsButtonType {
    
    case music, haptics

    var image: Image {
        switch self {
            
        case .music: Image(systemName: "speaker.wave.3.fill")
            
        case .haptics:
            Image(systemName: "iphone.gen1.radiowaves.left.and.right")
            
        }
    }
    
    var text: Text {
        switch self {
            
        case .music: Text("Music")
            
        case .haptics: Text("Haptics")
        }
    }
    
}

#Preview {
    SettingsComponent(type: .haptics)
}
