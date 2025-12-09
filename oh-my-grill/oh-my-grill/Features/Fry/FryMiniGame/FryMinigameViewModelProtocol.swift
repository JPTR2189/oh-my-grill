//
//  FryMinigameViewModelProtocol.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 06/12/25.
//

import Foundation

protocol FryMinigameViewModelProtocol {
    var session: GameSession { get }
    var greenZoneWidth: Double { get set }
    var safeZoneOffset: Double { get set }
    var normalizedPosition: Double { get }
    var sensorBarWidth: Int { get }
    var sensorColor: SensorColorController { get set }
    var sensorController: CMMotionController { get set }
    var potatoIsFried: Bool { get set }
    func intervalNormalizer(currentValue: Double, oldMinValue: Double, oldMaxValue: Double, newMinValue: Double, newMaxValue: Double) -> Double
    func updateGreenZoneWidth(size: Double)
    func updateSafeZoneOffset(size: Double)
    func isCenter() -> Bool
    func growGreenZone()
    func updateMotion()
}
