//
//  JoinView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 21/11/25.
//

import SwiftUI

struct JoinView: View {
    private var vc: any JoinViewControllerProtocol
    
    @State private var nextView: Bool = false

    init(transport: any TransportSessionProtocol) {
        self.vc = JoinViewController(transport: transport)
    }

    var body: some View {
        
        NavigationStack {
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
                                buttonAction: {
                                    vc.insertToPassword(String(number))
                                    print(vc.rawPassword)
                                },
                                text: String(number),
                                size: .small
                            )
                        }
                    }
                    
                    HStack(spacing: 28) {
                        ForEach(5...8, id: \.self) { number in
                            PasswordComponent(
                                buttonAction: {
                                    vc.insertToPassword(String(number))
                                    print(vc.rawPassword)
                                },
                                text: String(number),
                                size: .small
                            )
                        }
                    }
                    
                    ButtonComponent(
                        buttonAction: {
                            vc.tryToJoin(withPassword: vc.rawPassword)
                        },
                        text: "Start Game",
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $nextView) {
                LobbyView(transport: vc.transport)
            }
            .onAppear {
                vc.transport.setNotificationHandler(self)
                vc.transport.startBrowsing()
            }
            .onDisappear {
                vc.transport.stopBrowsing()
            }
        }
    }
}

// MARK: - Notification Delegate
extension JoinView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .accepted:
            self.nextView = true
            
        default: break
        }
    }
}
