//
//  FryViewModel.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 05/12/25.
//

import Foundation
internal import UIKit

@Observable
class FryMinigameViewModel: FryMinigameViewModelProtocol {

    var sensorColor: SensorColorController = SensorColorController()
    var sensorController: CMMotionController = CMMotionController()
    let session: GameSession
    
    var potatoIsFried: Bool = false
    var greenZoneWidth = 0.0
    var safeZoneOffset = 0.0
    var greenZoneSide = 0
        
    var normalizedPosition = 0.5
    
    // INVERSION
    
    let directionMultiplier: Double = -1.0
    
    let calibrationOffset: Double = 0.6
    
    func isCenter() -> Bool {
        return (normalizedPosition >= sensorColor.minSafe) && (normalizedPosition <= sensorColor.maxSafe)
    }
    
    var sensorBarWidth: Int {
        400
    }
    

    
    var round: Round? {
        session.currentRound
    }
    
    func updateGreenZoneWidth(size: Double) {
        
        self.greenZoneWidth = size * (self.sensorColor.maxSafe - self.sensorColor.minSafe)
        
        
    }
    
    func updateSafeZoneOffset(size: Double) {
        
        self.safeZoneOffset = size * self.sensorColor.minSafe
        
    }
    
    func growGreenZone() {
        greenZoneSide = greenZoneSide == 0 ? 1 : 0
        
        if greenZoneWidth <= Double(sensorBarWidth) {
            HapticManager.instance.impact(style: .heavy)

            self.greenZoneWidth += 1
            
            self.safeZoneOffset = greenZoneSide == 0 ? self.safeZoneOffset - 1 : self.safeZoneOffset
            
        }
        
        else {
            potatoIsFried = true
            SoundEffectsManager.instance.playMiniGame()
        }
    }
    
    
    func intervalNormalizer(currentValue: Double, oldMinValue: Double, oldMaxValue: Double, newMinValue: Double, newMaxValue: Double) -> Double {
            let clampedValue = min(max(currentValue, oldMinValue), oldMaxValue)
            return newMinValue + (((clampedValue - oldMinValue) * (newMaxValue - newMinValue)) / (oldMaxValue - oldMinValue))
        }
    
    func startMonitoring() {
        sensorController.startMotionUpdates()
    }
    
    func stopMonitoring() {
        sensorController.stopMotionUpdates()
    }
    
    func updateMotion() {
            let sensitivity = 0.5
            
            // 1. Pegamos o valor bruto
            let rawValue = sensorController.roll
            
            // 2. Aplicamos a calibração (Trazemos o "zero" para a sua posição de mão)
            let calibratedValue = (rawValue - calibrationOffset)
            
            // 3. Aplicamos a direção (Inverte esquerda/direita se necessário)
            let finalValue = calibratedValue * directionMultiplier
            
            // 4. Normalizamos para mover a barra
            self.normalizedPosition = intervalNormalizer(
                currentValue: finalValue,
                oldMinValue: -sensitivity,
                oldMaxValue: sensitivity,
                newMinValue: 0.0,
                newMaxValue: 1.0
            )
        }
    
    init(session: GameSession) {
        self.session = session
    }
    
    
}
