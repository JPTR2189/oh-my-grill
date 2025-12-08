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
    
    let rootNode = SKNode()
    let plateSprite = SKSpriteNode(imageNamed: "plate")
    
    let burgerRoot = SKNode()
    
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
        
        plateSprite.setScale(3.5)
        rootNode.addChild(plateSprite)
        
        rootNode.zPosition = -1
        
        rootNode.name = "plate"
        
        rootNode.physicsBody = SKPhysicsBody(circleOfRadius: bodySize)
        rootNode.physicsBody?.affectedByGravity = false
        rootNode.physicsBody?.isDynamic = false
        rootNode.physicsBody?.categoryBitMask = PhysicsCategory.plate
        rootNode.physicsBody?.collisionBitMask = PhysicsCategory.parcel | PhysicsCategory.wall | PhysicsCategory.gateWay
        rootNode.physicsBody?.contactTestBitMask = PhysicsCategory.parcel
        rootNode.physicsBody?.linearDamping = 7
        rootNode.physicsBody?.angularDamping = 7
        
        rootNode.zPosition = 0
        
                
        burgerRoot.position = CGPoint(x: 0, y: baseOffset)
        burgerRoot.zPosition = baseOffset
        rootNode.addChild(burgerRoot)

        
        addComponent(GKSKNodeComponent(node: rootNode))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func stackIngredient(_ ingredient: SKIngredient, manager: EntityManager) -> Bool {
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
//        guard !(stack.count == 0 && ingredient.ingredient.type != .bottomBun)
//        else {
//            print("Bottom bun needed to start stacking")
//            return false
//        }
        
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
        
        let newIngredient = SKIngredient(for: ingredient.ingredient)
        guard let newNode = newIngredient.node
        else {
            print("Couldn extract node from new ingredient")
            return false
        }
        /***/
        
        
        if let body = newNode.physicsBody {
            body.categoryBitMask = 0
            body.collisionBitMask = 0
            body.contactTestBitMask = 0
            body.isDynamic = false
            body.angularVelocity = 0
        }
        
        
        if ingredientNode.parent != nil {
            manager.remove(entity: ingredient)
        }
        
        
        burgerRoot.addChild(newNode)
        
        
        let offset: CGFloat = CGFloat(stack.count) * stackingOffset
        newNode.position = CGPoint(x: 0, y: offset)
        newNode.zPosition = CGFloat(stack.count) + 1
        
        
        stack.append(newIngredient)
        
        
        if newIngredient.ingredient.type == .topBun {
            releaseBurger(manager: manager)
        }
        
        return true
    }
    
    private func releaseBurger(manager: EntityManager) {
        guard let plateNode = node,
              let scene = plateNode.scene
        else { return }
        
        print("Releasing burger with \(stack.count) ingredients")
        
        let worldPos = burgerRoot.convert(rootNode.position, to: scene)
        
        burgerRoot.removeFromParent()
        
        let burgerEntity = SKBurger(fromRoot: burgerRoot)
        burgerEntity.node?.position = worldPos
        manager.add(entity: burgerEntity)
        
        stack.removeAll()
        let newBurgerRoot = SKNode()
        newBurgerRoot.position = CGPoint(x: 0, y: baseOffset)
        newBurgerRoot.zPosition = 5
        plateNode.addChild(newBurgerRoot)
        self.burgerRoot.removeAllChildren()
    }
}

extension SKPlate {
    static let name = "plate"
}
