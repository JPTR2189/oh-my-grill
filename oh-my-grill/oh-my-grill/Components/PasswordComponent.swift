//
//  PasswordComponent.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 19/11/25.
//

import SwiftUI

enum Size {
    case large
    case small

    var frameSize: CGFloat {
        switch self {
        case .large: 86
        case .small: 70
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .large: 38
        case .small: 31
        }
    }
}

struct PasswordComponent: View {
    var buttonAction: (() -> Void)? = nil
    var text: String
    var isDisabled: Bool = false
    var size: Size = .large

    var body: some View {
        Button {
            self.buttonAction?()
        } label: {
            Text(text)
                .font(.custom("Toy Block Maestro", size: size.fontSize))
                .foregroundStyle(.white)
                .frame(width: size.frameSize, height: size.frameSize)
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
