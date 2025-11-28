//
//  Ingredient.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 28/11/25.
//

import Foundation

import GameplayKit
import SpriteKit

class IngredientEntity: GKEntity {
    
    // O nó visual que a gente vê na tela
    var renderNode: SKSpriteNode
    
    init(imageName: String) {
        // 1. Cria o Sprite
        let texture = SKTexture(imageNamed: imageName)
        self.renderNode = SKSpriteNode(texture: texture)
        
        super.init()
        
        // 2. Configura o Componente Visual (GKSKNodeComponent)
        // Isso conecta a entidade ao SpriteKit
        let nodeComponent = GKSKNodeComponent(node: renderNode)
        addComponent(nodeComponent)
        
        // 3. Configura a Física (IMPORTANTE para ser jogado)
        // Usamos circleOfRadius para simplificar, ou use texture se preferir precisão
        let physicsBody = SKPhysicsBody(circleOfRadius: max(renderNode.size.width, renderNode.size.height) / 2)
        
        physicsBody.isDynamic = true // Precisa ser true para aceitar forças (empurrão)
        physicsBody.allowsRotation = true
        physicsBody.friction = 0.5
        physicsBody.restitution = 0.5 // Quica um pouco
        physicsBody.linearDamping = 0.5 // Resistência do ar (para não voar para sempre)
        
        // Configura as categorias de colisão (ajuste conforme seu PhysicsCategory)
        // physicsBody.categoryBitMask = ...
        // physicsBody.collisionBitMask = ...
        
        renderNode.physicsBody = physicsBody
        
        // 4. Componente Arrastável (Se você tiver essa classe no seu projeto)
        // Isso permite que o seu 'handleMovementUpdate' controle ele
        let draggable = DraggableComponent() // Certifique-se de que essa classe existe no seu projeto
        addComponent(draggable)
        
        // Define nome para identificação
        renderNode.name = imageName
    }
    
    // Helper para definir posição (igual a Ball)
    func setPosition(to point: CGPoint) {
        renderNode.position = point
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
