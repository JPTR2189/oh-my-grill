//
//  PasswordComponent.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 19/11/25.
//

import SwiftUI

enum Size {
    case large
    case medium
    case small
    
    var frameSize: CGFloat {
        switch self {
        case .large: 86
        case .medium: 58
        case .small: 35
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .large: 38
        case .medium: 25
        case .small: 16
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .large: 8
        case .medium: 8
        case .small: 5
        }
    }
}

struct PasswordComponent: View {
    var buttonAction: (() -> Void)? = nil
    var text: String
    var isDisabled: Bool = false
    var size: Size = .large
    var bgColor: Color?
    var isError: Bool = false
    
    var body: some View {
        Button {
            HapticManager.instance.notification(type: .success)
            SoundEffectsManager.instance.playClick()

            self.buttonAction?()
        } label: {
            Text(text)
                .font(.custom("Toy Block Maestro", size: size.fontSize))
                .foregroundStyle(.white)
                .frame(width: size.frameSize, height: size.frameSize)
                .background(
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .foregroundStyle(bgColor ?? .texasCherry)
                        .shadow(
                            color: .texasBrown,
                            radius: 0.5,
                            x: 0,
                            y: 4
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .stroke(isError ? Color.red : Color.clear, lineWidth: 3)
                )
        }
        .disabled(isDisabled)
    }
}
