//
//  NewGameView.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 19/11/25.
//

import SwiftUI

struct NewGameView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: any NewGameViewModelProtocol

    var body: some View {
        ZStack(alignment: .center) {

            //MARK: Background
            Image(.backgroundOut)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .tint(.white)
                    .padding(.horizontal, 15)
                    .padding(.top, 11)
                    .padding(.bottom, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 7)
                            .foregroundStyle(.accent)
                            .shadow(
                                color: .texasBrown,
                                radius: 0.5,
                                x: 0,
                                y: 5
                            )
                    )
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(.top, 16)
            .padding(.leading, 16)

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("NEW MATCH")
                        .font(.custom("Toy Block Maestro", size: 55))
                    Text(
                        "Type your name and enter a existing match/create your own to start playing!"
                    )
                    .font(.custom("Poppins Regular", size: 15))
                    .multilineTextAlignment(.center)
                }
                .foregroundColor(.texasBlack)

                TextField(
                    "",
                    text: $viewModel.username,
                    prompt: Text("USERNAME")
                        .font(.custom("Toy Block Maestro", size: 23))
                        .foregroundStyle(.texasWhite)
                )
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
                    Button {
                        guard !viewModel.username.isEmpty else { return }
                        viewModel.transport = TransportSession(
                            userName: viewModel.username
                        )
                    } label: {
                        Text("CREATE")
                            .font(.custom("Toy Block Maestro", size: 23))
                            .tint(.white)
                            .padding(.horizontal, 38)
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

                    Button {
                        guard !viewModel.username.isEmpty else { return }
                        viewModel.transport = TransportSession(
                            userName: viewModel.username
                        )
                    } label: {
                        Text("JOIN")
                            .font(.custom("Toy Block Maestro", size: 23))
                            .tint(.white)
                            .padding(.horizontal, 54)
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
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 25)
        }
        .navigationBarBackButtonHidden(true)
    }
}
