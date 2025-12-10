//
//  ViewModel.swift
//  oh-my-grill-POC
//
//  Created by Jean Pierre on 19/11/25.
//

import Foundation
import SwiftUI

class SensorColorController {
    
    // SAFE ZONE
    let minSafe: Double = 0.45
    let maxSafe: Double = 0.57
    
    func backgroundColor(for normalizedValue: Double) -> Color {
        // Se o valor (0.0 a 1.0) estiver dentro da zona, é VERDE
        if normalizedValue >= minSafe && normalizedValue <= maxSafe {
            return Color.green
        }
        
        // Se estiver fora, calcula o gradiente para vermelho
        let distance: Double
        if normalizedValue < minSafe {
            distance = minSafe - normalizedValue
        } else {
            distance = normalizedValue - maxSafe
        }
        
        let maxDangerDistance = 0.20
        let intensity = min(distance / maxDangerDistance, 1.0)
        
        let redComponent = min(intensity * 2.0, 1.0)
        let greenComponent = max(1.0 - (intensity - 0.5) * 2.0, 0.0)
        
        return Color(red: redComponent, green: greenComponent, blue: 0)
    }
}
