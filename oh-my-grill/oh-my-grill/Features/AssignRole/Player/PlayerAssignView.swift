//
//  PlayerAssignView.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 25/11/25.
//

import SwiftUI

struct PlayerAssignView: View {

    @State private var nextView: Bool = false

    var body: some View {

        NavigationStack {
            Group {

                Text("Player Assign Viwe")
                    .font(.largeTitle)

                Text("Waiting for host to do assign roles")
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $nextView) {
            
            }
        }
    }
}

// MARK: -
extension PlayerAssignView: MPCNotificationDelegate {
    func notify(_ notification: MPCNotifications) {
        switch notification {
        case .nextView:
            self.nextView = true

        default: break
        }
    }
}
