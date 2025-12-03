//
//  JoinView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 21/11/25.
//

import SwiftUI

struct JoinView: View {
    @State private var vc: JoinViewController

    @State private var nextView: Bool = false
    @State private var wrongPassword: Bool = false

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
                
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Enter the game")
                            .font(.custom("Toy Block Maestro", size: 40))
                        Text(
                            "Enter the room code to start the game."
                        )
                        .font(.custom("Poppins Regular", size: 12))
                        .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.texasBlack)
                    
                    HStack(spacing: 10) {
                        ForEach(0...3, id: \.self) { number in
                            let char = number < vc.password.count ? vc.password[number] : ""
                            let passwordChar = char.isEmpty ? "" : char
                            
                            PasswordComponent(
                                text: passwordChar,
                                isDisabled: true,
                                size: .small,
                                bgColor: .texasBlack,
                                isError: wrongPassword
                            )
                        }
                        
                        Button {
                            vc.removeFromPassword()
                            wrongPassword = false
                        } label: {
                            Image(systemName: "delete.left")
                                .font(.custom("Toy Block Maestro", size: 16))
                                .foregroundStyle(.white)
                                .frame(width: 35, height: 35)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundStyle(.texasBlack)
                                        .shadow(
                                            color: .texasBrown,
                                            radius: 0.5,
                                            x: 0,
                                            y: 4
                                        )
                                )
                            
                        }
                    }
                    
                    HStack(spacing: 16) {
                        ForEach(1...4, id: \.self) { number in
                            PasswordComponent(
                                buttonAction: {
                                    vc.insertToPassword(String(number))
                                    print(vc.rawPassword)
                                },
                                text: String(number),
                                size: .medium,
                                isError: false
                            )
                        }
                    }
                    
                    HStack(spacing: 16) {
                        ForEach(5...8, id: \.self) { number in
                            PasswordComponent(
                                buttonAction: {
                                    vc.insertToPassword(String(number))
                                    print(vc.rawPassword)
                                },
                                text: String(number),
                                size: .medium,
                                isError: false
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
                LobbyView(transport: vc.transport, password: vc.password)
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

func setError(to state: Bool) {
    if state {
        
    }
}

// MARK: - Notification Delegate
extension JoinView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        print("JoinView.notify called with: \(notification)")
        switch notification {
        case .accepted:
            self.nextView = true
            break

        case .wrongPassword:
            print("wrongPassword case received")
            wrongPassword = true

        default: break
        }
    }
}
