//
//  ViewModel.swift
//  oh-my-grill-POC
//
//  Created by Jean Pierre on 19/11/25.
//

import Foundation
import SwiftUI

class SensorViewModel {
     
    func backgroundColor(for value: Double) -> Color {
        // SAFE ZONE
        let minSafe = 0.500000
        let maxSafe = 0.600000
        
        if value >= minSafe && value <= maxSafe {
            return Color.green
        }
        
        // 2. Calcular a Distância
        let distance: Double
        if value < minSafe {
            distance = minSafe - value
        } else {
            distance = value - maxSafe
        }
        

        let maxDangerDistance = 0.20
        
        let intensity = min(distance / maxDangerDistance, 1.0)
        
        // 4. Mistura de Cores (Verde -> Amarelo -> Vermelho)
       
        
        let redComponent = min(intensity * 2.0, 1.0)
        
        // Se intensity for menor que 0.5, mantemos o verde em 1.0
        let greenComponent = max(1.0 - (intensity - 0.5) * 2.0, 0.0)
        
        return Color(red: redComponent, green: greenComponent, blue: 0)
    }

    
    
}
