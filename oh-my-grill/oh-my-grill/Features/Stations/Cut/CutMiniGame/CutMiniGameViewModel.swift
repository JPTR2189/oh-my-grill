//
//  CutMiniGameViewModel.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 25/11/25.
//

import CoreMotion
import Foundation
import Combine
import SwiftUI

@Observable
class CutMiniGameViewModel: CutMiniGameViewModelProtocol {
    private let service: MotionServiceProtocol

    var currentAccelerationX: Double = 0.0
    var gestureCount: Int = 0
    var gestureComplete: Bool = false
    let requiredGestures = 5
    private let accelerationThreshold: Double = 1.5
    var currentState: CutStateEnum = .readyForDownMove
    let indicatorScale: Double = 60
    let session: GameSession

    var progressAmount: Double {
        return Double(gestureCount) / Double(requiredGestures)
    }
    
    var round: Round? {
        session.currentRound
    }
    
    init(motionService: MotionServiceProtocol = MotionService(), session: GameSession) {
        self.service = motionService
        self.session = session
        self.startMotionUpdates()
    }
    
    private func startMotionUpdates() {
        self.gestureComplete = false
        self.currentState = .readyForDownMove
        self.gestureCount = 0
        
        service.startUpdates { [weak self] data in
            guard let self = self, !self.gestureComplete else {
                self?.service.stopUpdates()
                return
            }
            
            let accelerationX = data.userAcceleration.x
            self.processAcceleration(accelerationX)
        }
    }
    
    private func processAcceleration(_ accelerationValue: Double) {
        
        self.currentAccelerationX = accelerationValue
        
        switch self.currentState {
            
        case .readyForDownMove:
            if accelerationValue > self.accelerationThreshold {
                self.currentState = .waitingForUpReverse
            }
            
        case .waitingForUpReverse:
            if accelerationValue < -self.accelerationThreshold {
                self.gestureCount += 1
                
                HapticManager.instance.impact(style: .heavy)
                
                self.currentState = .readyForDownMove
                
                if self.gestureCount >= self.requiredGestures {
                    self.gestureComplete = true

                    HapticManager.instance.notification(type: .success)
                }
            }
        }
    }
    
    func resetGesture() {
        service.stopUpdates()
        self.startMotionUpdates()
    }
    
    deinit {
        service.stopUpdates()
    }
}
