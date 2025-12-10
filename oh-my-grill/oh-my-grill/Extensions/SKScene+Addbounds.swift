//
//  SKScene+Addbounds.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 09/12/25.
//

import Foundation
import SpriteKit

extension SKScene {
    func addBounds(withGateway: Bool = false) {
        let thickness: CGFloat = 2

        
        let leftNode = SKNode()
        leftNode.position = CGPoint(x: frame.minX, y: frame.midY)
        leftNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: thickness, height: frame.height))
        leftNode.physicsBody?.isDynamic = false
        leftNode.physicsBody?.categoryBitMask = PhysicsCategory.wall
        leftNode.physicsBody?.collisionBitMask = PhysicsCategory.parcel
        leftNode.physicsBody?.contactTestBitMask = 0
        addChild(leftNode)

        
        let rightNode = SKNode()
        rightNode.position = CGPoint(x: frame.maxX, y: frame.midY)
        rightNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: thickness, height: frame.height))
        rightNode.physicsBody?.isDynamic = false
        rightNode.physicsBody?.categoryBitMask = PhysicsCategory.wall
        rightNode.physicsBody?.collisionBitMask = PhysicsCategory.parcel
        rightNode.physicsBody?.contactTestBitMask = 0
        addChild(rightNode)

        
        let bottomNode = SKNode()
        bottomNode.position = CGPoint(x: frame.midX, y: frame.minY)
        bottomNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: thickness))
        bottomNode.physicsBody?.isDynamic = false
        bottomNode.physicsBody?.categoryBitMask = PhysicsCategory.wall
        bottomNode.physicsBody?.collisionBitMask = PhysicsCategory.parcel
        bottomNode.physicsBody?.contactTestBitMask = 0
        addChild(bottomNode)
        
        
        if withGateway {
            let gatewayNode = SKNode()
            gatewayNode.name = "gateway"
            gatewayNode.position = CGPoint(x: frame.midX, y: frame.maxY)
            gatewayNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: thickness))
            gatewayNode.physicsBody?.isDynamic = false
            gatewayNode.physicsBody?.categoryBitMask = PhysicsCategory.gateWay
            gatewayNode.physicsBody?.collisionBitMask = PhysicsCategory.parcel | PhysicsCategory.burger
            gatewayNode.physicsBody?.contactTestBitMask = PhysicsCategory.burger
            addChild(gatewayNode)
        }
    }
    
    func addChaosBounds(withGateway: Bool = false) {
        let thickness: CGFloat = 2
        
        let bottomNode = SKNode()
        bottomNode.position = CGPoint(x: frame.midX, y: frame.minY)
        bottomNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: thickness))
        bottomNode.physicsBody?.isDynamic = false
        bottomNode.physicsBody?.categoryBitMask = PhysicsCategory.wall
        bottomNode.physicsBody?.collisionBitMask = PhysicsCategory.parcel
        bottomNode.physicsBody?.contactTestBitMask = 0
        addChild(bottomNode)
        
        if withGateway  {
            if withGateway {
                let gatewayNode = SKNode()
                gatewayNode.name = "gateway"
                gatewayNode.position = CGPoint(x: frame.midX, y: frame.maxY)
                gatewayNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: thickness))
                gatewayNode.physicsBody?.isDynamic = false
                gatewayNode.physicsBody?.categoryBitMask = PhysicsCategory.gateWay
                gatewayNode.physicsBody?.collisionBitMask = PhysicsCategory.parcel | PhysicsCategory.burger
                gatewayNode.physicsBody?.contactTestBitMask = PhysicsCategory.burger
                addChild(gatewayNode)
            }
        } else {
            let topNode = SKNode()
                topNode.position = CGPoint(x: frame.midX, y: frame.maxY)
                topNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: thickness))
                topNode.physicsBody?.isDynamic = false
                topNode.physicsBody?.categoryBitMask = PhysicsCategory.wall
                topNode.physicsBody?.collisionBitMask = PhysicsCategory.parcel
                topNode.physicsBody?.contactTestBitMask = 0
                addChild(topNode)
        }
    }
}
