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
    
    var ingredient: Ingredient {
        didSet {
            let texture = SKTexture(imageNamed: ingredient.imageName)
            
            let old = oldValue.state.rawValue
            let new = ingredient.state.rawValue
            
            print(self)
            
            print("Changing texture from \(old) to \(new)")
            print("From \(oldValue.imageName) to \(ingredient.imageName)")
            
            if let sNode = spriteNode {
                print("Got sprite node")
                spriteNode?.texture = texture
                sNode.texture = texture
            }
        }
    }
    
    var spriteNode: SKSpriteNode? {
        node as? SKSpriteNode
    }
    
    var node: SKNode? {
        component(ofType: GKSKNodeComponent.self)?.node
    }
    
    var body: SKPhysicsBody? {
        node?.physicsBody
    }
    
    public init(for ingredient: Ingredient) {
        self.ingredient = ingredient
        
        super.init()
                
        let texture = SKTexture(imageNamed: ingredient.imageName)

        let node = SKSpriteNode(texture: texture)
        
        node.setScale(0.8)
        
        node.name = ingredient.type.rawValue
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: bodySize)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = PhysicsCategory.parcel
        node.physicsBody?.collisionBitMask = PhysicsCategory.parcel | PhysicsCategory.wall | PhysicsCategory.gateWay | PhysicsCategory.plate
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
    
    deinit {
        print("\(self.ingredient.type.displayName) deinited")
    }
}

extension SKIngredient {
    static let name = "ingredient"
}
