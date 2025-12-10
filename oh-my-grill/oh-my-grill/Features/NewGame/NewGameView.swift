//
//  NewGameView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 19/11/25.
//

import SwiftUI

struct NewGameView: View {
    @State var viewModel: any NewGameViewModelProtocol
    
    @State private var gotoHost: Bool = false
    @State private var gotoJoin: Bool = false
    
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
                        Text("NEW MATCH")
                            .font(.custom("Toy Block Maestro", size: 55))
                            .accessibilityIdentifier("newGameTitle")
                        VStack {
                            Text("Type your name and enter a existing match/create")
                            Text("our own to start playing!")
                        }
                        .font(.custom("Poppins Regular", size: 15))
                        .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.texasBlack)
                    
                    TextField(
                        "USERNAME",
                        text: $viewModel.username
                    )
                    .accessibilityIdentifier("USERNAME")
                    .font(.custom("Toy Block Maestro", size: 23))
                    .foregroundStyle(.white)
                    .tint(.texasWhite)
                    .padding(.vertical, 15)
                    .multilineTextAlignment(.center)
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
                    .frame(width: 350)
                    
                    //MARK: Buttons
                    HStack(spacing: 32) {
                        ButtonComponent (
                            buttonAction: {
                                guard !viewModel.username.isEmpty else { return }
                                viewModel.transport = TransportSession(
                                    userName: viewModel.username
                                )
                                gotoHost = true
                            },
                            text: String(localized: "Create"),
                            paddingHorizontal: 38
                        )
                        .accessibilityIdentifier("hostButton")
                        
                        ButtonComponent (
                            buttonAction: {
                                guard !viewModel.username.isEmpty else { return }
                                viewModel.transport = TransportSession(
                                    userName: viewModel.username
                                )
                                gotoJoin = true
                            },
                            text: String(localized: "Join"),
                        )
                        .accessibilityIdentifier("joinButton")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 25)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $gotoHost) {
                if let transport = viewModel.transport {
                    HostView(transport: transport)
                }
            }
            .navigationDestination(isPresented: $gotoJoin) {
                if let transport = viewModel.transport {
                    JoinView(transport: transport)
                }
            }
        }
        .onDisappear {
            viewModel.clearTextfield()
        }
    }
}
