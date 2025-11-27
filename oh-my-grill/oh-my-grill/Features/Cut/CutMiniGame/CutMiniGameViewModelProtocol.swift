//
//  CutMiniGameViewModelProtocol.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 25/11/25.
//

import Foundation

protocol CutMiniGameViewModelProtocol {
    
    var currentAccelerationX: Double { get }
    var gestureCount: Int { get }
    var gestureComplete: Bool { get }
    var currentState: CutStateEnum { get }
    var requiredGestures: Int { get }
    var indicatorScale: Double { get }
    var progressAmount: Double { get }
    var round: Round? { get }
                
    func resetGesture()
}
