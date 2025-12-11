//
//  FryScene.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 27/11/25.
//

import GameplayKit
import SpriteKit

public final class ChaosFryScene: SKScene {
    // MARK: Properties

    private var session: GameSession

    // Entity manager
    private var entityManager: EntityManager?

    // Dragging-related variables
    private var isDragging = false
    private var currentDrag: GKEntity?
    private var targetPoint: CGPoint?

    //Collision with the fryer
    public var onFryerCollision: ((SKIngredient) -> Void)?

    //Fryer Node
    private let fryerNode: SKSpriteNode = SKSpriteNode(imageNamed: "fryer")

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
        onFryerCollision: ((SKIngredient) -> Void)? = nil
    ) {
        self.session = session
        self.onFryerCollision = onFryerCollision
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

        // MARK: Fryer
        fryerNode.name = "fryer"
        fryerNode.position = CGPoint(
            x: fryerNode.size.width / 2 + 84,
            y: fryerNode.size.height / 2,
        )
        addChild(fryerNode)

        //MARK: Ingredients table

        self.entityManager = EntityManager(scene: self)

        print("First entry on FryScene")

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
extension ChaosFryScene {
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
extension ChaosFryScene {

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

        guard let ingredient = node.entity as? SKIngredient
        else {
            print("Couldns convert node into SKIngredient")
            print(node)
            return
        }

        if ingredient.ingredient.type == .potato && ingredient.ingredient.state == .base {
            onFryerCollision?(ingredient)
        }
        
        let payload = IngredientPayload(ingredient: ingredient.ingredient)
        self.session.notifyDelegate(.ingredient(payload))
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
