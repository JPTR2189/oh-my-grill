//
//  Color.swift
//  oh-my-grill-POC
//
//  Created by Jean Pierre on 18/11/25.
//

import Foundation
import SwiftUI

extension Color {
    init(red: Int, green: Int, blue: Int, opacity: Double = 1.0) {
        // Converte os valores Int (0-255) para Double (0.0-1.0)
        self.init(
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: opacity
        )
    }
    
    
    
    
}

