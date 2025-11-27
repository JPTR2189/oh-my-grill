//
//  PlayerAssignView.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 25/11/25.
//

import SwiftUI

struct PlayerAssignView: View {
    
    @State private var viewModel: any PlayerAssignViewModelProtocol
    
    init(transport: any TransportSessionProtocol) {
        self.viewModel = PlayerAssignViewModel(transport: transport)
    }
    
    @State private var nextView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                // Background
                Image(.backgroundOut)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                BackButtonComponent()
                
                Text("Ready:  1 / \(viewModel.playerLimit)") //TO DO: Colocar a quantidade de players prontos
                    .font(.custom("Poppins Bold", size: 17))
                    .foregroundColor(.texasBlack)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topTrailing
                    )
                    .padding(.top, 24)
                    .padding(.trailing, 24)
                
                
                VStack(spacing: 21) {
                    VStack(spacing: 8) {
                        Text("Lobby")
                            .font(.custom("Toy Block Maestro", size: 55))
                        Text("Wait for host define your function")
                            .font(.custom("Poppins Regular", size: 15))
                            .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.texasBlack)
                    
                    HStack(spacing: 24) { // TODO: Mudar para que cada posição apareça conforme o host assign
                        ForEach(0...3, id: \.self) { char in
                            AssignCardComponent(name: String(char), station: "Chef")
                        }
                    }
                    
//                    ButtonComponent (
//                        buttonAction: {  },
//                        text: "Ready",
//                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 25)
            }
            .navigationBarBackButtonHidden(true)
            .fullScreenCover(isPresented: $nextView) {
                if let session = viewModel.gameSession {
                    GameView(session: session)
                }
            }
        }
        .onAppear {
            viewModel.transport.setNotificationHandler(self)
        }
    }
}

// MARK: -
extension PlayerAssignView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .gameConfig(let payload):
            print("Game Config received")
            viewModel.gameSession = GameSession(transport: viewModel.transport, config: payload)
            
        default: break
        }
    }
}
