//
//  CMMotionController.swift
//  oh-my-grill-POC
//
//  Created by Jean Pierre on 14/11/25.
//

import Foundation
import CoreMotion

@Observable
class CMMotionController {
    private(set) var pitch: Double = 0.0
    private(set) var roll: Double = 0.0
    private(set) var yaw: Double = 0.0
    
    private let motionManager = CMMotionManager()
    
    var formatter = NumberFormatter()
    
    init() {
        startMotionUpdates()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "pt-BR")

    }
    
    deinit {
        stopMotionUpdates()
    }
    
    var isGyroAvailable: Bool {
        return motionManager.isGyroAvailable
    }
    
    var isMotionAvailable: Bool {
        return motionManager.isDeviceMotionAvailable
    }
    
    
    func startMotionUpdates() {
        if isMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / 30.0
            
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) {(data, error) in
                
                
                guard let data = data else { return }
                
                let attiude = data.attitude
                
                self.pitch = attiude.pitch
                self.roll = attiude.roll
                self.yaw = attiude.yaw
                
                
            }
        }
        
    }
    
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    
}
