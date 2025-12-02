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


        guard let plateNode = node
        else {
            print("Critical error on SKPlate: Couldnt find SKNode")
            return false
        }
        
        guard !(stack.count == 0 && ingredient.ingredient.type != .bottomBun)
        else {
            print("Bottom bun needed to start stacking")
            return false
        }
        
        if let lastType = stack.last?.ingredient.type {
            guard lastType != .topBun else {
                print("Cant stack after a top bun")
                return false
            }
        }
        
        guard let ingredientNode = ingredient.node
        else {
            print("Couldnt extract node frm ingredient")
            return false
        }
        
        guard let ingredientEntity = ingredientNode.entity as? SKIngredient
        else {
            print("Couldnt access ingredient's entity")
            return false
        }
        
        
        let parentNode: SKNode
        if let lastIngredientNode = stack.last?.node {
            parentNode = lastIngredientNode
        } else {
            parentNode = plateNode
        }
        
        
        let parentFrame = parentNode.calculateAccumulatedFrame()
        let newFrame = ingredientNode.calculateAccumulatedFrame()
        
        let offsetY = (parentFrame.height / 2) + (newFrame.height / 2)
        
        
        ingredientNode.position = .init(x: 0, y: offsetY)
        ingredientNode.zPosition = (stack.last?.node?.zPosition ?? plateNode.zPosition) + 1
        
        
        ingredientEntity.removeComponent(ofType: DraggableComponent.self)
            
        
            //        if ingredientNode.parent != nil {
//            ingredientNode.removeFromParent()
//        }
        
        
        if let body = ingredient.body {
            body.velocity = .zero
            body.angularVelocity = 0
            body.isDynamic = false
            body.categoryBitMask = 0
            body.collisionBitMask = 0
            body.contactTestBitMask = 0
        }
        
        
//        parentNode.addChild(ingredientNode)
        stack.append(ingredient)
        
        print("parent: \(String(describing: ingredientNode.parent))")
        
        return true
    }
}

extension SKPlate {
    static let name = "plate"
}
