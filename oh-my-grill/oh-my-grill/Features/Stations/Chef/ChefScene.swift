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
    
    private var burgers: [SKBurger] = []
    
    // Dragging-related variables
    private var isDragging = false
    private var currentDrag: GKEntity?
    private var targetPoint: CGPoint?
    
    // Ingredients table Node
    private let ingredientsTableNode: SKSpriteNode = SKSpriteNode(
        imageNamed: "ingredientsTable"
    )
    
    // Ingredient spawning point
    private var topBunSpawnPoint: CGPoint {
        return CGPoint(x: frame.minX + 200, y: frame.minY + 80)
    }
    private var bottomBunSpawnPoint: CGPoint {
        return CGPoint(x: frame.minX + 80, y: frame.minY + 80)
    }
    
    // Trash Can Node
    private let trashCanNode: SKSpriteNode = SKSpriteNode(imageNamed: "trashCan")
    
    // Background node
    private let backgroundNode = SKSpriteNode(imageNamed: "chefBackground")
    
    // Ingredient spawning
    private var isSpawning: Bool = false
    private let spawningInterval: TimeInterval = 3 // 10
    private let spawnerKey: String = "ingredientSpawner"
    
    // Plate node
    private var plate: SKPlate?
    
    var checkIsSendable: (_ burger: SKBurger) -> Bool
    
    
    //MARK: Initializers
    public init(size: CGSize, session: GameSession, check: @escaping (SKBurger) -> Bool) {
        self.session = session
        self.checkIsSendable = check
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didMove(to view: SKView) {
        self.size = view.bounds.size
        self.scaleMode = .resizeFill
        
        addBounds(withGateway: true)
        
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
        let centerPoint: CGPoint = .init(x: (frame.maxX / 3) * 2, y: (frame.maxY / 3))
        plate.node?.position = centerPoint
        entityManager?.add(entity: plate)
        
        
        // Test
//        let initialIngs: [Ingredient] = [
//            .init(type: .bottomBun, state: .base),
//            .init(type: .topBun, state: .base),
//            .init(type: .bottomBun, state: .base),
//            .init(type: .topBun, state: .base),
//        ]
        
//        for ing in initialIngs {
//            dropIngredient(ing)
//        }
        
        
        //MARK: Ingredients table
        
        self.entityManager = EntityManager(scene: self)
        
        print("First entry on CutScene")
        
        ingredientsTableNode.name = "ingredientsTable"
        ingredientsTableNode.position = CGPoint(
            x: frame.minX + 100,
            y: frame.minY + 30
        )
        ingredientsTableNode.zPosition = 1
        ingredientsTableNode.xScale = -1
        addChild(ingredientsTableNode)
        
        replenishIngredient(type: .burger)
        replenishIngredient(type: .cheese)
    }
    
    override public func didChangeSize(_ oldSize: CGSize) {
        backgroundNode.size = self.size
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }

    
    public override func update(_ currentTime: TimeInterval) {
        handleMovementUpdate()
        
        replenishIngredient(type: .topBun)
        replenishIngredient(type: .bottomBun)
        
    }
    
    private func replenishIngredient(type: IngredientType) {

        let point: CGPoint
        switch type {
        case .topBun:
            point = topBunSpawnPoint
        case .bottomBun:
            point = bottomBunSpawnPoint
        default:
            return
        }
        let entities = entityManager?.getEntities() ?? []

        let ingredientExists = entities.contains { entity in
            if let node = entity.component(ofType: GKSKNodeComponent.self)?
                .node,
                node.name == type.rawValue
            {
                return true
            }
            return false
        }

        if ingredientExists {
            return
        }

        let ingredientToSpawn = Ingredient(type: type, state: .base)
        let ingredientNode = SKIngredient(for: ingredientToSpawn)
        ingredientNode.setPosition(to: point)

        guard
            let node = ingredientNode.component(ofType: GKSKNodeComponent.self)?
                .node
        else {
            return
        }

        node.name = type.rawValue
        node.zPosition = 5
        node.alpha = 0.0

        let initialScale = node.xScale
        
        node.xScale = 0.3
        node.yScale = 0.3

        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        let scaleUpAction = SKAction.scale(to: initialScale, duration: 0.3)
        let spawnAnimation = SKAction.group([fadeInAction, scaleUpAction])

        entityManager?.add(entity: ingredientNode)

        print("REPLANISHING")

        node.run(spawnAnimation)
    }
    
    public func spawnIngredient(_ ingredient: Ingredient) {
        let ingredient = SKIngredient(for: ingredient)
        
        let x = frame.maxX / 3
        let y = frame.minY + 30
        
        ingredient.setPosition(to: .init(x: x, y: y))
        entityManager?.add(entity: ingredient)
        
        ingredient.body?.applyForce(.init(dx: 0, dy: 10000))
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
    
    func dropBurger() {
        let burger = [
            SKIngredient(for: .init(type: .bottomBun, state: .base)),
            SKIngredient(for: .init(type: .burger, state: .base)),
            SKIngredient(for: .init(type: .cheese, state: .base)),
            SKIngredient(for: .init(type: .topBun, state: .base))
        ]
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
        
        guard let nodeA = bodyA.node, let nodeB = bodyB.node else { return }
        
        if(nodeA.name == SKPlate.name || nodeB.name == SKIngredient.name) {
            if let plate = nodeA.entity as? SKPlate,
               let ingredient = nodeB.entity as? SKIngredient,
               let managet = entityManager {
                plate.stackIngredient(ingredient, manager: managet)
                HapticManager.instance.notification(type: .success)
            }
        }
        
        if(nodeA.name == "gateway" || nodeB.name == SKBurger.name) {
            if let burger = nodeB.entity as? SKBurger {
                let canGO = checkIsSendable(burger)
                print("Match found for burger: \(canGO)")
                if canGO {
                    currentDrag = nil
                    endDrag()
                    burger.body?.collisionBitMask = 0
                    burger.body?.velocity = .init(dx: 0, dy: 0)
                    burger.body?.applyForce(.init(dx: 0, dy: 100000))
                }
            }
        }
    }
}
