//
//  JoinView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 21/11/25.
//

import SwiftUI

struct JoinView: View {
    private var vc: any JoinViewControllerProtocol

    init(transport: any TransportSessionProtocol) {
        self.vc = JoinViewController(transport: transport)
    }

    var body: some View {
        ZStack(alignment: .center) {
            
            //MARK: Background
            Image(.backgroundOut)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            BackButtonComponent()
            
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Enter the game")
                        .font(.custom("Toy Block Maestro", size: 40))
                    Text(
                        "Enter the room code to start the game\nwith your friends."
                    )
                    .font(.custom("Poppins Regular", size: 16))
                    .multilineTextAlignment(.center)
                }
                .foregroundColor(.texasBlack)
                
                HStack(spacing: 28) {
                    
                    ForEach(1...4, id: \.self) { number in
                        PasswordComponent(
                            buttonAction: {print(number)},//TO DO: Button action
                            text: String(number),
                            size: .small
                        )
                    }
                }
                
                HStack(spacing: 28) {
                    ForEach(5...8, id: \.self) { number in
                        PasswordComponent(
                            buttonAction: {print(number)}, //TO DO: Button action
                            text: String(number),
                            size: .small
                        )
                    }
                }
                
                ButtonComponent(
                    buttonAction: {
                        print("") //TO DO: Button action
                    },
                    text: "Start Game",
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
