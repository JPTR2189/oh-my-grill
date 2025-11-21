//
//  HomeView.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 18/11/25.
//

import SwiftUI

struct HomeView: View {

    @State private var start: Bool = false

    var body: some View {

        NavigationStack {
            ZStack(alignment: .center) {
                //MARK: Fundo
                Image(.backgroundOut)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                //MARK: Conteúdo
                VStack(spacing: 25) {
                    Image(.logo)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 243)

                    Button {
                        start = true
                    } label: {

                        Text("Start Game")
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
                .padding(.top, 30)
            }
            .navigationDestination(isPresented: $start) {
                NewGameView(viewModel: NewGameViewModel())
            }
        }
    }
}

#Preview {
    HomeView()
}
