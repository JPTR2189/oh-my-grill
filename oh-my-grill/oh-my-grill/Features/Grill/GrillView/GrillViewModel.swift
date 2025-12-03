//
//  GrillViewModel.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 03/12/25.
//

import Foundation
import Observation
import CoreMotion

@Observable
class GrillViewModel {
    
    var nextView = false
    
    let session: GameSession
    
    var round: Round? {
        session.currentRound
    }
    
    init(session: GameSession) {
        self.session = session
    }
}
