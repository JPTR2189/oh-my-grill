//
//  LobbyView.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 25/11/25.
//

import SwiftUI

struct LobbyView: View {
    var vm: any LobbyViewModelProtocol
    @State private var nextView: Bool = false
    
    init(transport: any TransportSessionProtocol) {
            self.vm = LobbyViewModel(transport: transport)
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
                
                Text("Players:  \(vm.players) / 4")
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
                            "Wait for the host to start the game!"
                        )
                        .font(.custom("Poppins Regular", size: 15))
                        .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.texasBlack)
                }
            }
            .onAppear {
                vm.transport.setNotificationHandler(self)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $nextView) {
                PlayerAssignView(transport: vm.transport)
            }
        }
    }
}

// MARK: -
extension LobbyView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .nextView:
            self.nextView = true
            
        default: break
        }
    }
}
