//
//  ChefViewModel.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 25/11/25.
//

import Foundation

@Observable
class ChefViewModel {
    private let session: GameSession

    init(session: GameSession) {
        self.session = session
    }

    var orders: [Order] {
        session.currentOrders
    }

    var round: Round? {
        session.currentRound
    }
}
