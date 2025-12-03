//
//  ChefScene.swift
//  oh-my-grill
//
//  Created by Maria Santellano on 24/11/25.
//

import SpriteKit
import GameplayKit
import SwiftUI

public final class ChefScene: SKScene {

    // MARK: Properties

    private var viewModel = ChefSceneViewModel()

    private var session: GameSession

    

    // Entity manager

    var entityManager: EntityManager?

    

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
    private let spawningInterval: TimeInterval = 10
    private let spawnerKey: String = "ingredientSpawner"
    
    

    var nívelDeEmpilhamentoAtual: CGFloat = 10

       

    var pratoNode: SKSpriteNode?

    



    let nomeBotaoSpawn = "btn_spawn"

    let nomeBotaoLimpar = "btn_limpar"

    let nomeIngrediente = "ingrediente"

    let nomePrato = "prato"

    

    

    //MARK: Initializers

    public init(size: CGSize, session: GameSession) {

        self.session = session

        super.init(size: size)

        viewModel.scene = self

    }

    

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }

    

    override public func didMove(to view: SKView) {

        self.size = view.bounds.size

        self.scaleMode = .resizeFill



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

        // MARK: Organizer
        
        viewModel.criarBancada()

        // MARK: Ingredient

        


        viewModel.criarPratoRedondo()
        viewModel.criarPratoRedondo(isPotato: true)

        

    }

    

    override public func didChangeSize(_ oldSize: CGSize) {

        backgroundNode.size = self.size

        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)

//        entityManager?.add(entity: initialIngredient)
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
        let x: CGFloat = CGFloat.random(in: frame.minX...frame.maxX)
        let y: CGFloat = frame.maxY
        let point = CGPoint(x: x, y: y)
        let ingredient = Ingredient.getRandom()
        
        print("Dropping: \(ingredient.state.rawValue) \(ingredient.type.displayName)")
        
        let ingredientNode = SKIngredient(for: ingredient)
        ingredientNode.setPosition(to: point)
        entityManager?.add(entity: ingredientNode)
        ingredientNode.body?.applyForce(.init(dx: 0, dy: -20000))
    }
    
    public func startSpawning() {
        isSpawning = true
        
        let wait = SKAction.wait(forDuration: spawningInterval)
        let spawn = SKAction.run { [weak self] in
            guard let self = self, self.isSpawning else { return }
            self.dropRandomIngredient()
        }
        
        let sequence = SKAction.sequence([wait, spawn])
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

    

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }

        let location = touch.location(in: self)

        

        // --- 1. PRIMEIRO: Verifica a UI (Botões) ---

        // A UI tem prioridade sobre o jogo. Se clicou no botão, faz a ação e sai.

        let nodesTocados = nodes(at: location)

        

        for node in nodesTocados {

            // Verifica se clicou no Spawn

            if node.name == nomeBotaoSpawn {

                viewModel.spawnIngrediente()

                return

            }

            // Verifica se clicou no Limpar

            if node.name == nomeBotaoLimpar {

                viewModel.limparTudo()

                return

            }

        }

        

        // --- 2. SEGUNDO: Verifica Entidades (Drag System do EntityManager) ---

        // Agora usamos 'if let' em vez de 'guard' para não travar o resto do código se falhar

        if let manager = entityManager,

           let entity = manager.entity(at: location),

           entity.component(ofType: DraggableComponent.self) != nil,

           let node = manager.node(for: entity),

           let body = node.physicsBody {

            

            isDragging = true

            currentDrag = entity

            targetPoint = location

            body.angularVelocity = 0

            return // Se começou a arrastar uma entidade, paramos por aqui

        }

        

        // --- 3. TERCEIRO: Lógica de Arrastar da ViewModel (Prato/Ingredientes Soltos) ---

        // (Seu código original de arrastar o prato ou itens sem Entity)

        

        if let nodeTocado = nodesTocados.first(where: { node in

            if node.name == nomePrato { return true }

            if let nome = node.name, viewModel.opcoes.contains(nome) { return true }

            return false

        }) {

            

        }

    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // CASO 1: Se estiver arrastando uma Entidade (Physics)
        if isDragging {
            targetPoint = location
        }
        

    }

    

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {


        handleDropAndDeletion()

        endDrag()

    }

    

    override public func touchesCancelled( _ touches: Set<UITouch>, with event: UIEvent?) {

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
