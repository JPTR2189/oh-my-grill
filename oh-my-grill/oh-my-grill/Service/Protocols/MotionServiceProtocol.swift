//
//  MotionServiceProtocol.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 25/11/25.
//

import Foundation
import CoreMotion

protocol MotionServiceProtocol {
    func startUpdates(_ handler: @escaping (CMDeviceMotion) -> Void)
    func stopUpdates()
}
