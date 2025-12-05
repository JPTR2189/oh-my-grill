//
//  SKNode.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 02/12/25.
//

import Foundation
import SpriteKit
import CoreImage

extension SKNode {
    
    /// Adiciona um Drop Shadow (sombra projetada) ao nó.
    /// - Parameters:
    ///   - color: Cor da sombra (Padrão: Preto).
    ///   - opacity: Opacidade de 0.0 a 1.0 (Padrão: 0.5).
    ///   - offset: Deslocamento X e Y da sombra (Padrão: 10, -10).
    ///   - radius: Raio do desfoque/blur. Se 0, a sombra é sólida e rápida. Se > 0, usa SKEffectNode (mais pesado).
    ///   - layer: A posição Z relativa ao objeto. -1 fica atrás, 1 fica na frente.
    func addDropShadow(color: UIColor = .black,
                       opacity: CGFloat = 0.5,
                       offset: CGSize = CGSize(width: 10, height: -10),
                       radius: CGFloat = 0,
                       layer: CGFloat = -1) {
        
        // 1. Limpeza: Remove sombra anterior para evitar duplicação
        self.childNode(withName: "dropShadow_container")?.removeFromParent()
        
        // 2. Copia o nó atual para criar a forma da sombra
        guard let shadowNode = self.copy() as? SKNode else { return }
        
        // 3. Configurações básicas da cópia
        shadowNode.name = "shadow_shape"
        shadowNode.position = .zero
        shadowNode.alpha = opacity
        shadowNode.xScale = 1.0
        shadowNode.yScale = 1.0
        shadowNode.zRotation = 0
        
        shadowNode.removeAllChildren()
        
        // 4. Pinta a sombra da cor escolhida (Preto) dependendo do tipo de nó
        if let sprite = shadowNode as? SKSpriteNode {
            sprite.color = color
            sprite.colorBlendFactor = 1.0
            sprite.blendMode = .alpha
        } else if let shape = shadowNode as? SKShapeNode {
            shape.fillColor = color
            shape.strokeColor = color 
            shape.glowWidth = 0
        } else if let label = shadowNode as? SKLabelNode {
            label.fontColor = color
        }
        
        // 5. Lógica de Container e Blur
        let shadowContainer: SKNode
        
        if radius > 0 {
            let effectNode = SKEffectNode()
            effectNode.shouldEnableEffects = true
            
            let filter = CIFilter(name: "CIGaussianBlur")
            filter?.setValue(radius, forKey: kCIInputRadiusKey)
            effectNode.filter = filter
            
            shadowContainer = effectNode
        } else {
            shadowContainer = SKNode()
        }
        
        // 6. Configuração Final do Container
        shadowContainer.name = "dropShadow_container"
        shadowContainer.position = CGPoint(x: offset.width, y: offset.height)
        shadowContainer.zPosition = layer
        
        // Adiciona a forma pintada dentro do container
        shadowContainer.addChild(shadowNode)
        
        // Adiciona o container ao objeto original
        self.addChild(shadowContainer)
    }
}
