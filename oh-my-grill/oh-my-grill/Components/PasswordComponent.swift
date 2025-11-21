//
//  PasswordComponent.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 19/11/25.
//

import SwiftUI

struct PasswordComponent: View {
    var buttonAction: (() -> Void)? = nil
    var text: String
    var paddingVertical: CGFloat
    var paddingHorizontal: CGFloat
    var isDisabled: Bool = false

    var body: some View {
        Button {
            self.buttonAction?()
        } label: {
            Text(text)
                .font(.custom("Toy Block Maestro", size: 31))
                .foregroundStyle(.white)
                .padding(.horizontal, paddingHorizontal)
                .padding(.vertical, paddingVertical)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.texasCherry)
                        .shadow(
                            color: .texasBrown,
                            radius: 0.5,
                            x: 0,
                            y: 4
                        )
                )
        }
        .disabled(isDisabled)
    }
}
