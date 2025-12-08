//
//  ButtonComponent.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 19/11/25.
//

import SwiftUI

struct ButtonComponent: View {
    var buttonAction: () -> Void
    var text: String
    var paddingHorizontal: CGFloat?
    var isDisabled: Bool?
    var isNotButton: Bool = false

    var body: some View {
        if isNotButton {
            Text(text)
                .font(.custom("Toy Block Maestro", size: 23))
                .foregroundStyle(.white)
                .padding(.horizontal, paddingHorizontal ?? 56)
                .padding(.top, 15)
                .padding(.bottom, 12)
                .background(
                    RoundedRectangle(cornerRadius: 11)
                        .foregroundStyle(.accent)
                        .shadow(
                            color: .texasBrown,
                            radius: 0.5,
                            x: 0,
                            y: 7
                        )
                )
        } else {
            Button {
                buttonAction()
            } label: {
                Text(text)
                    .font(.custom("Toy Block Maestro", size: 23))
                    .tint(.white)
                    .padding(.horizontal, paddingHorizontal ?? 56)
                    .padding(.top, 15)
                    .padding(.bottom, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .foregroundStyle(.accent)
                            .shadow(
                                color: .texasBrown,
                                radius: 0.5,
                                x: 0,
                                y: 7
                            )
                    )
            }
            .disabled(isDisabled ?? false)
        }
    }
}
