//
//  ChefScene.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 24/11/25.
//

import SpriteKit
import GameplayKit

public final class ChefScene: SKScene {
    // MARK: Properties
    
    // Entity manager
    private var entityManager: EntityManager?
    
    // Dragging-related variables
    private var isDragging = false
    private var currentDrag: GKEntity?
    private var targetPoint: CGPoint?
    
    // Trash Can Node
    private let trashCanNode: SKSpriteNode = SKSpriteNode(imageNamed: "trashCan")
    
    //MARK: Initializers
    public override init(size: CGSize) {
            super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didMove(to view: SKView) {
        self.size = view.bounds.size
        self.scaleMode = .resizeFill
        
        physicsWorld.gravity = .init(dx: 0, dy: 0)
        self.entityManager = EntityManager(scene: self)
        
        trashCanNode.name = "trashCan"
        
        //TO DO: Change the trash location
        trashCanNode.position = CGPoint(
            x: trashCanNode.size.width / 2 + 16,
            y: 0 + 48
        )
        trashCanNode.setScale(0.3) //TO DO: Change the trash size
        addChild(trashCanNode)
        
        // TO DO: Change to the ingredient stop being the ball
        let initialIngredient = Ball()
        
        // TO DO: Change the initial position for the ingredient
        let centerPoint = CGPoint(x: frame.midX, y: frame.midY)
        initialIngredient.setPosition(to: centerPoint)
        
        entityManager?.add(entity: initialIngredient)
        
    }
    
    public override func update(_ currentTime: TimeInterval) {
        handleMovementUpdate()
    }
}

// MARK: - Touch Input & Drag Mechanics
extension ChefScene {
    
    override public func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard
            let touch = touches.first,
            let manager = entityManager
        else { return }
        
        let location = touch.location(in: self)
        
        guard
            let entity = manager.entity(at: location),
            entity.component(ofType: DraggableComponent.self) != nil,
            let node = manager.node(for: entity),
            let body = node.physicsBody
        else { return }
        
        isDragging = true
        currentDrag = entity
        targetPoint = location
        
        body.angularVelocity = 0
    }
    
    override public func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard isDragging, let touch = touches.first else { return }
        targetPoint = touch.location(in: self)
    }
    
    override public func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        handleDropAndDeletion()
        endDrag()
    }
    
    override public func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        endDrag()
    }
    
    private func handleMovementUpdate() {
        guard
            let manager = entityManager,
            let entity = currentDrag,
            let node = manager.node(for: entity),
            let body = node.physicsBody,
            let target = targetPoint
        else { return }
        
        node.zRotation = .zero
        
        let pos = node.position
        let dx = target.x - pos.x
        let dy = target.y - pos.y
        let dist = sqrt(dx * dx + dy * dy)
        
        if dist < 0.5 {
            body.velocity = .zero
            return
        }
        
        let stiffness: CGFloat = 20
        let damping: CGFloat = 10
        
        let desiredVx = dx * stiffness
        let desiredVy = dy * stiffness
        
        let steerX = desiredVx - body.velocity.dx
        let steerY = desiredVy - body.velocity.dy
        
        let force = CGVector(dx: steerX * damping, dy: steerY * damping)
        body.applyForce(force)
        
        let maxSpeed: CGFloat = 1000
        var velocity = body.velocity
        let speed = hypot(velocity.dx, velocity.dy)
        if speed > maxSpeed {
            velocity.dx = velocity.dx / speed * maxSpeed
            velocity.dy = velocity.dy / speed * maxSpeed
            body.velocity = velocity
        }
    }
    
    private func handleDropAndDeletion() {
        guard
            let manager = entityManager,
            let entity = currentDrag,
            let node = manager.node(for: entity)
        else { return }
        
        if node.frame.intersects(trashCanNode.frame) {
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let remove = SKAction.removeFromParent()
            
            node.run(SKAction.sequence([fadeOut, remove])) {
                manager.remove(entity: entity)
                print("Ingredient deleted!")
            }
        } else {
            node.run(SKAction.scale(to: 0.2, duration: 0.1)) // TO DO: Fix the scale of the object
        }
    }
    
    private func endDrag() {
        defer {
            currentDrag = nil
            targetPoint = nil
            isDragging = false
        }
        
        guard
            let manager = entityManager,
            let entity = currentDrag,
            let node = manager.node(for: entity),
            let body = node.physicsBody
        else { return }
        
        body.isDynamic = true
        body.angularVelocity = 0
    }
}
