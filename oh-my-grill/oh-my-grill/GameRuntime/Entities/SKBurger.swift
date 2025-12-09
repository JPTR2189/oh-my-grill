//
//  SKBurger.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 08/12/25.
//

import Foundation
import SpriteKit
import GameplayKit

public class SKBurger: GKEntity {
    
    let width: CGFloat = 40
    let baseHeight: CGFloat = 20
    
    var height: CGFloat {
        baseHeight * CGFloat(stack.count)
    }
    
    var size: CGSize {
        .init(width: width, height: height)
    }
    
    let offset: CGFloat = 10
    
    var stack: [SKIngredient]
    
    var node: SKNode? {
        component(ofType: GKSKNodeComponent.self)?.node
    }
    
    var body: SKPhysicsBody? {
        node?.physicsBody
    }
    
    public init(fromStack stack: [SKIngredient]) {
        self.stack = stack
        super.init()
        
        let node = SKNode()
        node.name = SKBurger.name
        node.zPosition = 1
        
        let body = SKPhysicsBody(rectangleOf: size)
        
        body.affectedByGravity = false
        body.isDynamic = true
        body.categoryBitMask = PhysicsCategory.burger
        body.collisionBitMask = PhysicsCategory.wall | PhysicsCategory.gateWay  | PhysicsCategory.burger | PhysicsCategory.parcel
        body.contactTestBitMask = 0
        body.linearDamping = 7
        body.angularDamping = 7
        
        node.physicsBody = body
        
        var currentHeight: CGFloat = 0
        
        for (idx, ing) in stack.enumerated() {
            guard let originalNode = ing.node as? SKSpriteNode else { continue }
            
            let sprite = SKSpriteNode(texture: originalNode.texture)
            sprite.size = originalNode.size
            sprite.anchorPoint = .init(x: 0.5, y: 0.5)
            
            let y = currentHeight + offset
            sprite.position = .init(x: 0, y: y)
            sprite.zPosition = CGFloat(idx)
            
            node.addChild(sprite)
            
            currentHeight += offset
        }
        
        addComponent(GKSKNodeComponent(node: node))
        
        let draggable = DraggableComponent()
        addComponent(draggable)
        
        print("Burger initialized with \(stack.count) ingredients")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKBurger {
    static let name = "burger"
}
