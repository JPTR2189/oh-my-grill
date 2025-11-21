//
//  PasswordComponent.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 19/11/25.
//

import SwiftUI

enum Size { case large, small }

struct PasswordComponent: View {
    var buttonAction: (() -> Void)? = nil
    var text: String
    var isDisabled: Bool = false
    var size: Size = .large
    
    var frameSize: CGFloat {
        size == .large ? 86 : 70
    }
    
    var fontSize: CGFloat {
        size == .large ? 38 : 31
    }

    var body: some View {
        Button {
            self.buttonAction?()
        } label: {
            Text(text)
                .font(.custom("Toy Block Maestro", size: 31))
                .foregroundStyle(.white)
                .frame(width: frameSize, height: frameSize)
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
