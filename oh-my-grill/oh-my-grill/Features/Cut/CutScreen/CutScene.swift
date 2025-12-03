//
//  CutScene.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 27/11/25.
//

import GameplayKit
import SpriteKit

public final class CutScene: SKScene {
    // MARK: Properties

    private var session: GameSession

    // Entity manager
    private var entityManager: EntityManager?

    // Dragging-related variables
    private var isDragging = false
    private var currentDrag: GKEntity?
    private var targetPoint: CGPoint?

    //CHAT
    public var onKnifeCollision: ((SKIngredient) -> Void)?

    // Ingredients table Node
    private let ingredientsTableNode: SKSpriteNode = SKSpriteNode(
        imageNamed: "ingredientsTable"
    )

    //Knife Node
    private let knifeNode: SKSpriteNode = SKSpriteNode(imageNamed: "knife")

    // Background node
    private let backgroundNode = SKSpriteNode(imageNamed: "backgroundStation")

    // Ingredient spawning point
    private var tomatoSpawnPoint: CGPoint {
        return CGPoint(x: frame.maxX - 200, y: frame.minY + 80)
    }
    private var lettuceSpawnPoint: CGPoint {
        return CGPoint(x: frame.maxX - 80, y: frame.minY + 80)
    }

    //MARK: Initializers
    public init(
        size: CGSize,
        session: GameSession,
        onKnifeCollision: ((SKIngredient) -> Void)? = nil
    ) {
        self.session = session
        self.onKnifeCollision = onKnifeCollision
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

        // MARK: Knife
        knifeNode.name = "knife"
        knifeNode.position = CGPoint(
            x: knifeNode.size.width / 2 + 84,
            y: knifeNode.size.height / 2 + 52,
        )
        knifeNode.setScale(1.4)
        addChild(knifeNode)

        //MARK: Ingredients table

        self.entityManager = EntityManager(scene: self)

        print("First entry on CutScene")

        ingredientsTableNode.name = "ingredientsTable"
        ingredientsTableNode.position = CGPoint(
            x: frame.maxX - 130,
            y: frame.minY + 50
        )
        ingredientsTableNode.zPosition = 1
        addChild(ingredientsTableNode)

        replenishIngredient(type: .tomato)
        replenishIngredient(type: .lettuce)

        print("Entities:")
        if let entities = entityManager?.getEntities() {
            for entity in entities {
                print(entity)
            }
        }
    }

    override public func didChangeSize(_ oldSize: CGSize) {
        backgroundNode.size = self.size
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }

    public override func update(_ currentTime: TimeInterval) {
        handleMovementUpdate()

        //        replenishIngredient(type: .tomato)
        //        replenishIngredient(type: .lettuce)

        guard let entities = entityManager?.getEntities() else { return }

        for entity in entities {
            if let node = entity.component(ofType: GKSKNodeComponent.self)?.node
            {
                if let side = exitSide(for: node) {
                    print(
                        "Ball from \(session.myID.rawValue) exited to the \(side)"
                    )
                    sendParcelHorizontally(
                        side: side,
                        node: node,
                        entity: entity
                    )
                }
            }
        }
    }

    private func replenishIngredient(type: IngredientType) {

        let point: CGPoint
        switch type {
        case .tomato:
            point = tomatoSpawnPoint
        case .lettuce:
            point = lettuceSpawnPoint
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
        node.xScale = 0.5
        node.yScale = 0.5

        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        let scaleUpAction = SKAction.scale(to: 1.0, duration: 0.3)
        let spawnAnimation = SKAction.group([fadeInAction, scaleUpAction])

        entityManager?.add(entity: ingredientNode)

        print("REPLANISHING")

        node.run(spawnAnimation)
    }
}

// MARK: - Auxiliar Funcs
extension CutScene {
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
        entityManager?.remove(entity: entity)
        let dxFromCenter = node.position.x - frame.midX
        let mirroredDx = -dxFromCenter

        let payload = GamePayload(
            x: mirroredDx,
            y: node.position.y,
            side: side
        )

        session.sendParcelHorizontally(payload)
    }
}

// MARK: - Touch Input & Drag Mechanics
extension CutScene {

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

        if node.frame.intersects(knifeNode.frame) {
            let scaleDown = SKAction.scale(to: 0.8, duration: 0.2)
            node.run(scaleDown) {
                let payload = IngredientPayload(
                    ingredient: ingredient.ingredient
                )
                self.session.notifyDelegate(.ingredient(payload))
                
                if let function = self.onKnifeCollision {
                    function(ingredient)
                }
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
