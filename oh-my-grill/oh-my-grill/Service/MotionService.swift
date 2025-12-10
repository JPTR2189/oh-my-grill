//
//  MotionService.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 25/11/25.
//

import Foundation
import CoreMotion

class MotionService: MotionServiceProtocol {

    private let motion = CMMotionManager()

    func startUpdates(_ handler: @escaping (CMDeviceMotion) -> Void) {
        motion.deviceMotionUpdateInterval = 0.01
        
        motion.startDeviceMotionUpdates(to: .main) { data, _ in
            if let data = data {
                handler(data)
            }
        }
    }

    func stopUpdates() {
        motion.stopDeviceMotionUpdates()
    }
}
