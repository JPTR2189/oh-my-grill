//
//  BackButtonComponent.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 21/11/25.
//

import SwiftUI

struct BackButtonComponent: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            HapticManager.instance.notification(type: .success)

            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.title2)
                .tint(.white)
                .padding(.horizontal, 15)
                .padding(.top, 11)
                .padding(.bottom, 10)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundStyle(.accent)
                        .shadow(
                            color: .texasBrown,
                            radius: 0.5,
                            x: 0,
                            y: 5
                        )
                )
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .padding(.top, 16)
        .padding(.leading, 16)
    }
}

#Preview {
    BackButtonComponent()
}
