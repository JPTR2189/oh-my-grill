//
//  GrillMiniGameViewModel.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 02/12/25.
//

import Foundation
import Observation
import CoreMotion
internal import UIKit

@Observable
class GrillMiniGameViewModel {

    private let service: MotionServiceProtocol

    var didRotate360 = false
    private var lastRoll: Double = 0
    private var accumulated: Double = 0
    private var firstReading = true
    private var currentDirection: Int = 0
    
    var ingredient: SKIngredient
    let session: GameSession
    
    var round: Round? {
        session.currentRound
    }

    init(
        motionService: MotionServiceProtocol = MotionService(),
        session: GameSession,
        ingredient: SKIngredient
    ) {
        self.service = motionService
        self.session = session
        self.ingredient = ingredient
        self.startMotionUpdates()
    }

    func startMotionUpdates() {
        service.startUpdates { motionData in
            self.process(rotation: motionData.attitude.roll)
        }
    }

    private func process(rotation roll: Double) {

        if firstReading {
            firstReading = false
            lastRoll = roll
            return
        }

        var delta = roll - lastRoll
        if delta > .pi { delta -= 2 * .pi }
        if delta < -.pi { delta += 2 * .pi }

        let dir = delta >= 0 ? 1 : -1

        if currentDirection == 0 { currentDirection = dir }

        if dir != currentDirection {
            accumulated = 0
            currentDirection = dir
        }

        accumulated += delta
        lastRoll = roll

        if abs(accumulated) >= (230 * .pi / 180) {
            HapticManager.instance.notification(type: .success)
            SoundEffectsManager.instance.playSuccess()
            didRotate360 = true
            service.stopUpdates()
        }
    }

    func stop() {
        service.stopUpdates()
    }
}
