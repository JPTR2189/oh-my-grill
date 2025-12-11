//
//  GrillScene.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 04/12/25.
//

import GameplayKit
import SpriteKit

public final class ChaosGrillScene: SKScene {
    // MARK: Properties
    
    private var session: GameSession
    
    // Entity manager
    private var entityManager: EntityManager?
    
    // Dragging-related variables
    private var isDragging = false
    private var currentDrag: GKEntity?
    private var targetPoint: CGPoint?
    
    public var onGrillCollision: ((SKIngredient) -> Void)?
    
    //Grill Node
    private let grillNode: SKSpriteNode = SKSpriteNode(imageNamed: "grill")
    
    // Background node
    private let backgroundNode = SKSpriteNode(imageNamed: "backgroundStation")
    
    // Ingredient spawning
    private var isSpawning: Bool = false
    private let spawningInterval: TimeInterval = 6 // 10
    private let spawnerKey: String = "ingredientSpawner"
    
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
    
    private func dropRandomIngredient() {
        let ingredient = Ingredient.getRandom()
        
        dropIngredient(ingredient)
    }
    
    func dropIngredient(_ ing: Ingredient) {
        let x: CGFloat = CGFloat.random(in: (frame.minX + 20)...(frame.maxX - 20))
        let y: CGFloat = frame.maxY
        let point = CGPoint(x: x, y: y)
        let ingredientNode = SKIngredient(for: ing)
        ingredientNode.setPosition(to: point)
        entityManager?.add(entity: ingredientNode)
        ingredientNode.body?.applyForce(.init(dx: 0, dy: -20000))
    }
    
    //MARK: Initializers
    public init(
        size: CGSize,
        session: GameSession,
        onGrillCollision: ((SKIngredient) -> Void)? = nil
    ) {
        self.session = session
        self.onGrillCollision = onGrillCollision
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didMove(to view: SKView) {
        self.size = view.bounds.size
        self.scaleMode = .resizeFill
        
        physicsWorld.gravity = .init(dx: 0, dy: 0)
        
        // MARK: Background
        backgroundNode.size = self.size
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -100
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(backgroundNode)
        
        // MARK: Grill
        grillNode.name = "grill"
        grillNode.position = CGPoint(
            x: grillNode.size.width / 2 + 300,
            y: grillNode.size.height / 2 + 100,
        )
        grillNode.setScale(2.3)
        addChild(grillNode)
        
        //MARK: Ingredients table
        
        self.entityManager = EntityManager(scene: self)
        
        print("First entry on CutScene")
        
        print("Entities:")
        if let entities = entityManager?.getEntities() {
            for entity in entities {
                print(entity)
            }
        }
        
        addChaosBounds()
    }
    
    override public func didChangeSize(_ oldSize: CGSize) {
        backgroundNode.size = self.size
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        handleMovementUpdate()
        
        guard let entities = entityManager?.getEntities() else { return }
        
        for entity in entities {
            if let node = entity.component(ofType: GKSKNodeComponent.self)?.node
            {
                if node.position.y >= frame.maxY {
                    sendParcelHorizontally(side: .none, node: node, entity: entity)
                }
            }
        }
    }
}

// MARK: - Auxiliar Funcs
extension ChaosGrillScene {
    private func exitSide(
        for node: SKNode,
        minExitVelocity velocity: CGFloat = 1
    ) -> EdgeSide? {
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
        entity: GKEntity
    ) {
        guard let skIngredient = entity as? SKIngredient else {
                return
            }
        entityManager?.remove(entity: entity)
        let dxFromCenter = node.position.x - frame.midX
        let mirroredDx = -dxFromCenter
        
        let payload = GamePayload(
            x: mirroredDx,
            y: node.position.y,
            side: side,
            ingredient: skIngredient.ingredient
        )
        
        session.sendParcelHorizontally(payload)
    }
}

// MARK: - Touch Input & Drag Mechanics
extension ChaosGrillScene {
    
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
        handleDropAndNextView()
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
    
    private func handleDropAndNextView() {
        guard
            let manager = entityManager,
            let entity = currentDrag,
            let node = manager.node(for: entity)
        else { return }
        
        print("Dropped")
        
        guard let ingredient = node.entity as? SKIngredient else {
            print("Couldn't convert node into SKIngredient")
            return
        }
        
        if node.frame.intersects(grillNode.frame) {
            
            //if cheese base
            if ingredient.ingredient.type == .cheese && ingredient.ingredient.state == .base {
                
                if let cookedBurgerEntity = findCookedBurgerOnGrill() {
                    print("Burger cheesed")
                    
                    if let burgerNode = entityManager?.node(for: cookedBurgerEntity),
                       let burgerIngredient = burgerNode.entity as? SKIngredient {
                        
                        guard !burgerIngredient.isCooking else {
                            print("Burger is not cooked! Can't add cheese.")
                            return
                        }
                        
                        //burger cheesed
                        burgerIngredient.ingredient.state = .cheesed
                        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1)
                        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                        burgerNode.run(.sequence([scaleUp, scaleDown]))
                        
                        session.showTimer = false
                        
                        releaseIngredientFromGrill(burgerNode)
                        
                        entityManager?.remove(entity: entity)
                        
                        // notify game
                        let payload = IngredientPayload(ingredient: burgerIngredient.ingredient)
                        self.session.notifyDelegate(.ingredient(payload))
                    }
                    
                    return
                }
            }
            
            // if burger base
            if ingredient.ingredient.type == .burger && ingredient.ingredient.state == .base {
                pinIngredientToGrill(node)
                onGrillCollision?(ingredient)
            }
            
            if ingredient.ingredient.type == .burger && ingredient.ingredient.state == .cooked {
                pinIngredientToGrill(node)
            }
            
            let payload = IngredientPayload(ingredient: ingredient.ingredient)
            self.session.notifyDelegate(.ingredient(payload))
        }
        
        let sceneRect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)

            if !sceneRect.contains(node.position) {
                print("Ingredient dropped outside, removing.")
                entityManager?.remove(entity: entity)
            }
    }
    
    
    private func findCookedBurgerOnGrill() -> GKEntity? {
        guard let entities = entityManager?.getEntities() else { return nil }
        
        for entity in entities {
            if let ingredientNode = entity.component(ofType: GKSKNodeComponent.self)?.node,
               let ingredient = ingredientNode.entity as? SKIngredient {
                
                if ingredient.ingredient.type == .burger &&
                    ingredient.ingredient.state == .cooked &&
                    ingredientNode.frame.intersects(grillNode.frame) {
                    
                    return ingredientNode.entity
                }
            }
        }
        
        return nil
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
    
    private func pinIngredientToGrill(_ ingredientNode: SKNode) {
        ingredientNode.position = grillNode.position
        ingredientNode.zPosition = grillNode.zPosition + 0.8

        ingredientNode.physicsBody?.velocity = .zero
        ingredientNode.physicsBody?.angularVelocity = 0
        ingredientNode.physicsBody?.isDynamic = false
        ingredientNode.physicsBody?.affectedByGravity = false
    }

    private func releaseIngredientFromGrill(_ ingredientNode: SKNode) {
        ingredientNode.physicsBody?.isDynamic = true
        ingredientNode.physicsBody?.affectedByGravity = false
    }

}
