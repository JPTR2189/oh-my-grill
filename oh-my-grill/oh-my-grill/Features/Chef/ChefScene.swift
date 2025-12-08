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
    
    private var viewModel = ChefSceneViewModel()
    private var session: GameSession
    
    // Entity manager
    private var entityManager: EntityManager?
    
    // Dragging-related variables
    private var isDragging = false
    private var currentDrag: GKEntity?
    private var targetPoint: CGPoint?
    
    // Trash Can Node
    private let trashCanNode: SKSpriteNode = SKSpriteNode(imageNamed: "trashCan")
    
    // Background node
    private let backgroundNode = SKSpriteNode(imageNamed: "chefBackground")
    
    // Ingredient spawning
    private var isSpawning: Bool = false
    private let spawningInterval: TimeInterval = 10 // Go back to 10 after testing
    private let spawnerKey: String = "ingredientSpawner"
    
    // Plate node
    private var plate: SKPlate?
    
    
    //MARK: Initializers
    public init(size: CGSize, session: GameSession) {
        self.session = session
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didMove(to view: SKView) {
        self.size = view.bounds.size
        self.scaleMode = .resizeFill
        
        addBounds()
        
        physicsWorld.contactDelegate = self

        physicsWorld.gravity = .init(dx: 0, dy: 0)
        self.entityManager = EntityManager(scene: self)

        // MARK: Background
        backgroundNode.size = self.size
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -100
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(backgroundNode)

        // MARK: Trash can
        trashCanNode.name = "trashCan"
        trashCanNode.position = CGPoint(
            x: frame.maxX - 60,
            y: frame.minY + 30
        )
        trashCanNode.setScale(1)
        addChild(trashCanNode)

        // Plate
        let plate = SKPlate()
        self.plate = plate
        let centerPoint: CGPoint = .init(x: frame.midX, y: frame.midY)
        plate.node?.position = centerPoint
        entityManager?.add(entity: plate)
    }
    
    override public func didChangeSize(_ oldSize: CGSize) {
        backgroundNode.size = self.size
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }

    
    public override func update(_ currentTime: TimeInterval) {
        handleMovementUpdate()
        
        guard let entities = entityManager?.getEntities() else { return }
        
        for entity in entities {
            
            var ingredient: Ingredient?
            
            if let ingredientNode = entity as? SKIngredient {
                ingredient = ingredientNode.ingredient
            }
            
            if let node = entity.component(ofType: GKSKNodeComponent.self)?.node {
                if let side = exitSide(for: node) {
                    print("Ball from \(session.myID.rawValue) exited to the \(side)")
                    
                    sendParcelHorizontally(side: side, node: node, entity: entity, ingredient: ingredient)
                }
            }
        }
    }
    
    public func spawnBall(at point: CGPoint, goingTo side: EdgeSide) {
        let ball = Ball()
        ball.setPosition(to: point)
        entityManager?.add(entity: ball)
        let direction: CGFloat = side == .right ? 1 : -1
        ball.body?.applyForce(.init(dx: 10000 * direction, dy: 0))
    }
    
    public func spawnIngredient(_ ingredient: Ingredient, at point: CGPoint, goingTo side: EdgeSide) {
        let ingredient = SKIngredient(for: ingredient)
        ingredient.setPosition(to: point)
        entityManager?.add(entity: ingredient)
        let direction: CGFloat = side == .right ? 1 : -1
        ingredient.body?.applyForce(.init(dx: 7500 * direction, dy: 0))
    }
    
    private func dropRandomIngredient() {
        let x: CGFloat = CGFloat.random(in: (frame.minX - 20)...(frame.maxX + 20))
        let y: CGFloat = frame.maxY
        let point = CGPoint(x: x, y: y)
        let ingredient = Ingredient.getRandom()
        
//        print("Dropping: \(ingredient.state.rawValue) \(ingredient.type.displayName)")
        
        let ingredientNode = SKIngredient(for: ingredient)
        ingredientNode.setPosition(to: point)
        entityManager?.add(entity: ingredientNode)
        ingredientNode.body?.applyForce(.init(dx: 0, dy: -20000))
    }
    
    func dropBurger() {
        let burger = [
            SKIngredient(for: .init(type: .bottomBun, state: .base)),
            SKIngredient(for: .init(type: .burger, state: .base)),
            SKIngredient(for: .init(type: .cheese, state: .base)),
            SKIngredient(for: .init(type: .topBun, state: .base))
        ]
        
        for ingredient in burger {
            let x: CGFloat = CGFloat.random(in: frame.minX...frame.maxX)
            let y: CGFloat = frame.maxY
            let point = CGPoint(x: x, y: y)
            
            ingredient.setPosition(to: point)
            entityManager?.add(entity: ingredient)
            ingredient.body?.applyForce(.init(dx: 0, dy: -20000))
        }
        
    }
    
    public func startSpawning() {
        isSpawning = true
        
        let wait = SKAction.wait(forDuration: spawningInterval)
        let spawn = SKAction.run { [weak self] in
            guard let self = self, self.isSpawning else { return }
            self.dropRandomIngredient()
        }
        
        let sequence = SKAction.sequence([spawn, wait])
        let forever = SKAction.repeatForever(sequence)
        
        self.run(forever, withKey: spawnerKey)
    }
    
    public func stopSpawning() {
        isSpawning = false
        self.removeAction(forKey: spawnerKey)
    }
    
    private func addBounds() {
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
    }
}

// MARK: - Auxiliar Funcs
extension ChefScene {
    private func exitSide(for node: SKNode, minExitVelocity velocity: CGFloat = 1) -> EdgeSide? {
        guard let body = node.physicsBody else { return nil }
        
        let accFrame = node.calculateAccumulatedFrame()
        
        if accFrame.maxX < frame.minX + 20, body.velocity.dx < -velocity {
            return .left
        }
        
        if accFrame.minX > frame.maxX - 20, body.velocity.dx > velocity {
            return .right
        }
        
        return nil
    }
    
    // Send parecl horizontally - Sends a parcel horizontally
    private func sendParcelHorizontally(
        side: EdgeSide,
        node: SKNode,
        entity: GKEntity,
        ingredient: Ingredient? = nil
    ) {
        entityManager?.remove(entity: entity)
        let dxFromCenter = node.position.x - frame.midX
        let mirroredDx = -dxFromCenter

        let payload = GamePayload(
            x: mirroredDx,
            y: node.position.y,
            side: side,
            ingredient: ingredient ?? .getRandom()
        )
        
        session.sendParcelHorizontally(payload)
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
            
            node.run(SKAction.scale(to: 0.2, duration: 0.4))
            node.run(SKAction.sequence([fadeOut, remove])) {
                manager.remove(entity: entity)
                print("Ingredient deleted!")
            }
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

// MARK: - Contact delegate
extension ChefScene: SKPhysicsContactDelegate {
    
    public func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        print("Contact")
        
        guard let nodeA = bodyA.node, let nodeB = bodyB.node else { return }
        
        if(nodeA.name == SKPlate.name || nodeB.name == SKIngredient.name) {
            if let plate = nodeA.entity as? SKPlate,
               let ingredient = nodeB.entity as? SKIngredient,
               let managet = entityManager {
                let stacked = plate.stackIngredient(ingredient, manager: managet)
                
                print("Stacked: \(stacked)")
                
//                
            }
            
        }
    }
}
