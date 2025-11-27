//
//  PhysicsManager.swift
//  oh-my-grill-POC
//
//  Created by Jean Pierre on 24/11/25.
//

import Foundation
import SpriteKit

import SpriteKit

class PhysicsManager: NSObject, SKPhysicsContactDelegate {
    
    weak var gameScene: GameScene2?
    
    init(scene: GameScene2) {
        self.gameScene = scene
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        guard let nodeA = bodyA.node, let nodeB = bodyB.node else { return }
        
        
        // Verifica se um dos nodos é o pratp
        if (nodeA.name == "prato" || nodeB.name == "prato") {
            print("Passou por cima do prato! Tocar som 'plop'.")
            
            // Fazer o som de um efeito ou animar o prato...
        }
    }
}


