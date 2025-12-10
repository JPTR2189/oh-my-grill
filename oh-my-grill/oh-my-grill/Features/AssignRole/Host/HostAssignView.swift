//
//  HostAssignView.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 25/11/25.
//

import MultipeerConnectivity
import SwiftUI

struct HostAssignView: View {

    @StateObject private var vm: HostAssignViewModel

    init(transport: TransportSessionProtocol) {
        _vm = StateObject(wrappedValue: HostAssignViewModel(transport: transport))
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
                        if let array = Array(vm.playerByRole.keys) as? [String]
                        {
                            ForEach(array.sorted { $0 < $1 }, id: \.self) {
                                key in
                                let value = vm.playerByRole[key] ?? ""
                                let name = String(value.prefix(2))
//                                let name = value

                                Menu {
                                    ForEach(vm.unassignedPlayers, id: \.self) {
                                        playerName in
                                        Button(playerName) {
                                            vm.assign(key, to: playerName)
                                        }
                                    }
                                } label: {
                                    AssignCardComponent(
                                        name: name,
                                        station: key
                                    )
                                }
                            }
                        }
                    }

                                        ButtonComponent (
                                            buttonAction: { vm.startGameIfReady() },
                                            text: "Ready",
                                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 25)
            }
            .navigationBarBackButtonHidden(true)
            .fullScreenCover(isPresented: $nextView) {
                if let gameSession = vm.gameSession {
                    ChefView(vm: ChefViewModel(session: gameSession))
                }
            }
        }
        .onAppear {
            vm.transport.setNotificationHandler(self)
        }
    }
}

// MARK: - Notification Delegate
extension HostAssignView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .nextView:
            self.nextView = true

        default: break
        }
    }
}
