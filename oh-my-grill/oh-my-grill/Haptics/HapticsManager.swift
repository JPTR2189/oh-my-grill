//
//  HapticsManager.swift
//  oh-my-grill
//
//  Created by Vítor Martins Da Silva on 04/12/25.
//

import SwiftUI

class HapticManager {

    static let instance = HapticManager()

    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

#Preview {
}
