//
//  SettingsButtonComponent.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 09/12/25.
//

import SwiftUI

struct SettingsButtonComponent: View {
    
    var body: some View {
        
        
        
        Image(systemName: "gearshape.fill")
            .font(.title2)
            .tint(.white)
            .padding(.horizontal, 15)
            .padding(.top, 11)
            .padding(.bottom, 10)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .frame(width: 48, height: 44)
                    .foregroundStyle(.accent)
                    .shadow(
                        color: .texasBrown,
                        radius: 0.5,
                        x: 0,
                        y: 5
                    )
            )
        .padding(.top, 24)
        .padding(.leading, 16)
    }
}

#Preview {
    SettingsButtonComponent()
}
