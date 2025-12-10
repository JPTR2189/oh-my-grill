//
//  FryViewModel.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 27/11/25.
//

import Foundation
import SpriteKit

@Observable
class ChaosFryViewModel: ChaosFryViewModelProtocol {
    let session: GameSession
    var nextView: Bool = false
    var lastIngredientSliced: Ingredient? = nil

    init(session: GameSession) {
        self.session = session
    }

    var round: Round? {
        session.currentRound
    }
}
