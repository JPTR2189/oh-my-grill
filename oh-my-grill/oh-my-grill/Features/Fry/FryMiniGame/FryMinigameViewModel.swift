//
//  FryViewModel.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 05/12/25.
//

import Foundation

@Observable
class FryMinigameViewModel: FryMinigameViewModelProtocol {
    
    let session: GameSession
    
    var round: Round? {
        session.currentRound
    }
    
    init(session: GameSession) {
        self.session = session
    }
    
    
}
