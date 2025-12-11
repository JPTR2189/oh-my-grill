//
//  FeedbackView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 27/11/25.
//

import SwiftUI

struct FeedbackView: View {
    let round: Round
    let session: GameSession
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // MARK: Background
            Image(.feedbackBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // MARK: Conteúdo
            VStack(alignment: .center, spacing: 24) {
                VStack(alignment: .center, spacing: 8) {
                    Text("Round \(round.number) completed")
                        .font(.custom("Toy Block Maestro", size: 55))
                        .foregroundStyle(.texasBlack)
                    Text("Keep it up and do it faster and faster.")
                        .font(.custom("Poppins Regular", size: 15))
                        .foregroundStyle(.texasBlack)
                }

                VStack(alignment: .center, spacing: 24) {
                    ButtonComponent(
                        buttonAction: {},
                        text: "\(round.points) points made",
                        isNotButton: true
                    )
                    ButtonComponent(
                        buttonAction: {},
                        text: "\(round.points / 10) orders placed",
                        isNotButton: true
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()

            // MARK: Next Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        HapticManager.instance.notification(type: .success)
                        session.startNewRound()
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.right")
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
                }
                .padding(.bottom, 24)
                .padding(.trailing, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    FeedbackView()
//}
