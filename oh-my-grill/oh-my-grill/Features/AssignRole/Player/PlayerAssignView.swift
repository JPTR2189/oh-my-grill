//
//  PlayerAssignView.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 25/11/25.
//

import SwiftUI

struct PlayerAssignView: View {
    
    @State private var vm: any PlayerAssignViewModelProtocol
    
    init(transport: any TransportSessionProtocol) {
        self.vm = PlayerAssignViewModel(transport: transport)
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
                
//                Text("Ready:  1 / \(viewModel.playerLimit)")
                Text("Connected: \(vm.players) / \(vm.playerLimit)")
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
                    
                    HStack(spacing: 24) {
                        if let array = Array(vm.playerByRole.keys) as? [String] {
                            ForEach(array.sorted{ $0 < $1 }, id: \.self) { key in
                                let value = vm.playerByRole[key] ?? ""
                                let name = String(value.prefix(2))
                                AssignCardComponent(name: name, station: key)
                            }
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
                if let session = vm.gameSession {
                    //ChefView(vm: ChefViewModel(session: session))
                    GrillMiniGameView(vm: GrillMiniGameViewModel(session: session))
                }
            }
        }
        .onAppear {
            vm.transport.setNotificationHandler(self)
        }
    }
}

// MARK: -
extension PlayerAssignView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .gameConfig(let payload):
            print("Game Config received")
            vm.gameSession = GameSession(transport: vm.transport, config: payload)
            nextView = true
            
        case .assignment(let payload):
            print(payload.playerByRole)
            vm.assignedRoles = payload.playerByRole
            
        default: break
        }
    }
}
