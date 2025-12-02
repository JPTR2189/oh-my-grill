//
//  SKIngredient.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 01/12/25.
//

import Foundation
import SpriteKit
import GameplayKit

public class SKIngredient: GKEntity {
    
    let bodySize: CGFloat = 40
    
    let ingredient: Ingredient
    
    var node: SKNode? {
        component(ofType: GKSKNodeComponent.self)?.node
    }
    
    var body: SKPhysicsBody? {
        node?.physicsBody
    }
    
    public init(for ingredient: Ingredient) {
        self.ingredient = ingredient
        
        super.init()
        
        let node = SKSpriteNode(imageNamed: ingredient.type.imageName)
        
        node.setScale(0.8)
        
        node.name = ingredient.type.rawValue
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: bodySize)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = PhysicsCategory.parcel
        node.physicsBody?.collisionBitMask = PhysicsCategory.parcel
        node.physicsBody?.contactTestBitMask = 0
        node.physicsBody?.linearDamping = 7
        node.physicsBody?.angularDamping = 7
        
        addComponent(GKSKNodeComponent(node: node))
        
        
        let draggableComponent = DraggableComponent()
        addComponent(draggableComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPosition(to point: CGPoint) {
        component(ofType: GKSKNodeComponent.self)?.node.position = point
    }
}
