//
//  SKPlate.swift
//  oh-my-grill
//
//  Created by João Pedro Teixeira de Carvalho on 02/12/25.
//

import Foundation
import SpriteKit
import GameplayKit

public class SKPlate: GKEntity {
    
    let bodySize: CGFloat = 30
    
    var ready: Bool = false
    
    var node: SKNode? {
        component(ofType: GKSKNodeComponent.self)?.node
    }
    
    var body: SKPhysicsBody? {
        node?.physicsBody
    }
    
    var stack: [SKIngredient] = []
    
    let baseOffset: CGFloat = 15
    let stackingOffset: CGFloat = 8
    
    override init() {
        super.init()
        
        let node = SKSpriteNode(imageNamed: "plate")
        
        node.setScale(3.5)
        
        node.zPosition = -1
        
        node.name = "plate"
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: bodySize)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = PhysicsCategory.plate
        node.physicsBody?.collisionBitMask = PhysicsCategory.parcel | PhysicsCategory.wall | PhysicsCategory.gateWay
        node.physicsBody?.contactTestBitMask = PhysicsCategory.parcel
        node.physicsBody?.linearDamping = 7
        node.physicsBody?.angularDamping = 7
        
        addComponent(GKSKNodeComponent(node: node))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func stackIngredient(_ ingredient: SKIngredient) -> Bool {
        print("Trying to stack \(ingredient.ingredient.type.displayName)")

        /* Preconditions */
        
        // Extracting plate node
        guard let plateNode = node
        else {
            print("Critical error on SKPlate: Couldnt find SKNode")
            return false
        }
        
        // Extracting ingredient node
        guard let ingredientNode = ingredient.node
        else {
            print("Couldnt extract node frm ingredient")
            return false
        }
        
        // Verifying for bottom bun to start stack
        guard !(stack.count == 0 && ingredient.ingredient.type != .bottomBun)
        else {
            print("Bottom bun needed to start stacking")
            return false
        }
        
        // Cant stack potatoes
        guard ingredient.ingredient.type != .potato
        else {
            print("Cant stack potatoes")
            return false
        }
        
        // Stack ended with top bun
        if let lastType = stack.last?.ingredient.type {
            guard lastType != .topBun else {
                print("Cant stack after a top bun")
                return false
            }
        }
        /***/
        
        
        ingredient.removeComponent(ofType: DraggableComponent.self)
        
        
//        if ingredientNode.parent != nil {
//            ingredientNode.removeFromParent()
//        }
//        
//        plateNode.addChild(ingredientNode)

        
        if let body = ingredient.body {
            body.velocity = .zero
            body.angularVelocity = 0
            body.isDynamic = false
            body.categoryBitMask = 0
            body.collisionBitMask = 0
            body.contactTestBitMask = 0
        }
        
        
        let parentNode: SKNode = stack.last?.node ?? plateNode
        
        print("Parent Node: \(parentNode)")
        
        
        let offSet: CGFloat = baseOffset + CGFloat(stack.count) * stackingOffset
        
        var targetPosition = plateNode.position
        targetPosition.y += offSet
        
        
        let moveAction = SKAction.move(to: targetPosition, duration: 0.0)
        ingredientNode.run(moveAction)
        
        
        ingredientNode.zPosition = (stack.last?.node?.zPosition ?? plateNode.zPosition) + 1
        
        
        stack.append(ingredient)
        
        
        if ingredient.ingredient.type == .topBun {
            let draggable = DraggableComponent()
            self.addComponent(draggable)
            
            self.body?.isDynamic = true
        }
        
        return true
    }
}

extension SKPlate {
    static let name = "plate"
}
