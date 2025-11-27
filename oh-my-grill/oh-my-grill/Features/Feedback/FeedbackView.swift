//
//  FeedbackView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 27/11/25.
//

import SwiftUI

struct FeedbackView: View {
    let round: Round

    var body: some View {
            ZStack(alignment: .center) {
                //MARK: Fundo
                Image(.backgroundOut)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.4)
                
                //MARK: Conteúdo
                VStack(alignment: .center, spacing: 25) {
                    Text(round.feedback == .success ? "Parabéns, time!" : "Mais sorte na próxima vez!")
                        .font(.custom("Toy Block Maestro", size: 38))
                        .foregroundStyle(.texasBrown)
                    Text("Rodada: \(round.number)")
                        .font(.custom("Poppins Regular", size: 24))
                        .foregroundStyle(.texasBlack)
                    Text("Pontos: \(round.points)")
                        .font(.custom("Poppins Regular", size: 24))
                        .foregroundStyle(.texasBlack)
                    Text("Feedback: \(round.feedback.displayName)")
                        .font(.custom("Poppins Regular", size: 24))
                        .foregroundStyle(.texasBlack)
                }
            }
    }
}


//#Preview {
//    FeedbackView()
//}
