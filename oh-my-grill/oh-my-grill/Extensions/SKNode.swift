//
//  SKNode.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 02/12/25.
//

import Foundation
import SpriteKit

extension SKNode {
    
    // Função para adicionar sombra
    func addDropShadow(color: UIColor = .black, opacity: CGFloat = 0.5, offset: CGSize = CGSize(width: 5, height: -5), blurRadius: CGFloat = 0) {
        
        // 1. Remove sombra anterior se já existir para evitar duplicação
        self.childNode(withName: "dropShadow")?.removeFromParent()
        
        // 2. Tenta criar uma cópia do nó atual
        // Usamos copy() para pegar a mesma textura/forma
        guard let shadowNode = self.copy() as? SKNode else {
            print("Erro: Não foi possível copiar o nó para criar a sombra.")
            return
        }
        
        // 3. Configura o nó da sombra
        shadowNode.name = "dropShadow"
        shadowNode.position = offset // Define o deslocamento relativo ao pai
        shadowNode.zPosition = -1 // Garante que fique atrás do nó original
        shadowNode.alpha = opacity // Define a transparência
        
        // 4. Pinta a sombra de preto (ou a cor escolhida)
        // Dependendo do tipo de nó, a forma de pintar muda:
        if let spriteShadow = shadowNode as? SKSpriteNode {
            spriteShadow.color = color
            spriteShadow.colorBlendFactor = 1.0 // 1.0 significa 100% da cor definida, ignorando a textura original
            spriteShadow.blendMode = .alpha // Garante que a transparência funcione corretamente
        } else if let shapeShadow = shadowNode as? SKShapeNode {
            shapeShadow.fillColor = color
            shapeShadow.strokeColor = color // Se tiver borda, pinta também
            shapeShadow.blendMode = .alpha
        } else if let labelShadow = shadowNode as? SKLabelNode {
            labelShadow.fontColor = color
            labelShadow.blendMode = .alpha
        }
        
        // 5. Remove quaisquer filhos que a cópia possa ter trazido junto
        shadowNode.removeAllChildren()
        
        // OBSERVAÇÃO SOBRE BLUR: O SpriteKit não tem um blur nativo fácil para nós.
        // Para um blur real, seria necessário usar SKEffectNode com um filtro CoreImage,
        // o que é custoso para performance. Se 'blurRadius' > 0, este método simples
        // não aplicará o blur.
        if blurRadius > 0 {
             print("Aviso: Este método simples não suporta blur real no SpriteKit. Para blur, use SKEffectNode.")
        }

        // 6. Adiciona o nó sombra como filho do nó original
        self.addChild(shadowNode)
    }
}
