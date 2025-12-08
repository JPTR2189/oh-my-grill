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
        // 1. Definir a Zona Segura (Verde)
        let minSafe = 0.500000
        let maxSafe = 0.600000
        
        // Se estiver dentro da zona, retorna Verde puro imediatamente
        if value >= minSafe && value <= maxSafe {
            return Color.green
        }
        
        // 2. Calcular a Distância (Quão "errado" está?)
        let distance: Double
        if value < minSafe {
            distance = minSafe - value // Está abaixo de 0.5
        } else {
            distance = value - maxSafe // Está acima de 0.6
        }
        
        // 3. Definir a "Tolerância de Perigo"
        // Se estiver 0.20 pontos longe da zona segura, já vira vermelho total.
        // Ex: 0.80 ou 0.30 já será vermelho sangue.
        let maxDangerDistance = 0.20
        
        // Calculamos a intensidade do erro de 0.0 (pouco erro) a 1.0 (erro máximo)
        let intensity = min(distance / maxDangerDistance, 1.0)
        
        // 4. Mistura de Cores (Verde -> Amarelo -> Vermelho)
        // No mundo das cores de luz (RGB):
        // Verde   = Red: 0, Green: 1
        // Amarelo = Red: 1, Green: 1
        // Vermelho= Red: 1, Green: 0
        
        // Aumentamos o vermelho conforme o erro cresce (para criar amarelo)
        let redComponent = min(intensity * 2.0, 1.0)
        
        // Diminuímos o verde SÓ DEPOIS que já ficou amarelo (na metade final do erro)
        // Se intensity for menor que 0.5, mantemos o verde em 1.0
        let greenComponent = max(1.0 - (intensity - 0.5) * 2.0, 0.0)
        
        return Color(red: redComponent, green: greenComponent, blue: 0)
    }

    
    
}
