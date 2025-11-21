//
//  HostView.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 21/11/25.
//

import SwiftUI

struct HostView: View {
    private var vc: any HostViewControllerProtocol
    
    init(transport: any TransportSessionProtocol) {
        self.vc = HostViewController(transport: transport)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            
            // Background
            Image(.backgroundOut)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            BackButtonComponent()
            
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("ROOM CODE")
                        .font(.custom("Toy Block Maestro", size: 55))
                    Text(
                        "Share the room code so your friends can join!"
                    )
                    .font(.custom("Poppins Regular", size: 15))
                    .multilineTextAlignment(.center)
                }
                .foregroundColor(.texasBlack)
                
                HStack(spacing: 24) {
                    ForEach(vc.password, id: \.self) { char in
                        PasswordComponent(text: char)
                    }
                }
                
                ButtonComponent (
                    buttonAction: {  },
                    text: "START GAME",
                )
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 25)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HostView(transport: TransportSession(userName: "Teste"))
}
