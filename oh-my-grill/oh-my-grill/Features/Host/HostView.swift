//
//  HostView.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 21/11/25.
//

import SwiftUI

struct HostView: View {
    private var vc: any HostViewControllerProtocol

    @State private var nextView: Bool = false

    init(transport: any TransportSessionProtocol) {
        self.vc = HostViewController(transport: transport)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {

                // Background
                Image(.backgroundOut)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                BackButtonComponent()
                
                Text("Players:  \(vc.players) / 4")
                    .font(.custom("Poppins Bold", size: 17))
                    .foregroundColor(.texasBlack)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topTrailing
                    )
                    .padding(.top, 24)
                    .padding(.trailing, 24)
                
                
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
                            PasswordComponent(
                                text: char,
                                isDisabled: true
                            )
                        }
                    }
                    
                    ButtonComponent (
                        buttonAction: { vc.startGame() },
                        text: "START GAME",
                    )
                    
                }
            }
            .navigationBarBackButtonHidden(true)

        }
    }
}

// MARK: - Notification Delegate
extension HostView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .nextView:
            self.nextView = true

        default: break
        }
    }
}
