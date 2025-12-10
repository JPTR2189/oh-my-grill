//
//  GrillViewModel.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 04/12/25.
//

import Foundation
import SpriteKit

@Observable
class GrillViewModel {
    let session: GameSession
    var nextView: Bool = false
    var lastIngredientGrilled: Ingredient? = nil

    init(session: GameSession) {
        self.session = session
    }

    var round: Round? {
        session.currentRound
    }
}
