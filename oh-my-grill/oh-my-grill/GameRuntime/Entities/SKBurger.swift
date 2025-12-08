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
    
    var node: SKNode? {
        component(ofType: GKSKNodeComponent.self)?.node
    }
    
    var body: SKPhysicsBody? {
        node?.physicsBody
    }
    
    public init(fromRoot root: SKNode) {
        super.init()
                
        let burgerFrame = root.calculateAccumulatedFrame()
        let body = SKPhysicsBody(rectangleOf: burgerFrame.size)
        
        body.affectedByGravity = false
        body.isDynamic = true
        body.collisionBitMask = PhysicsCategory.wall | PhysicsCategory.gateWay | PhysicsCategory.plate
        body.contactTestBitMask = PhysicsCategory.plate | PhysicsCategory.gateWay
        body.linearDamping = 1
        body.angularDamping = 1
        
        
        let node = root
        
        node.physicsBody = body
        
        addComponent(GKSKNodeComponent(node: node))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
