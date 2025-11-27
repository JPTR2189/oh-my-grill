//
//  GameScene.swift
//  oh-my-grill-POC
//
//  Created by Jean Pierre on 24/11/25.
//

import Foundation
import SpriteKit

class GameScene2: SKScene {
    
    var nodeSendoArrastado: SKNode?
    var viewModel = GameViewModel2()
//    var physicsManager: PhysicsManager!
    
    
    // Começamos com um valor base. O prato será 0. O primeiro item será 10, o segundo 11, etc.
    var nívelDeEmpilhamentoAtual: CGFloat = 10
    
   
    var pratoNode: SKSpriteNode?
    

    let nomeBotaoSpawn = "btn_spawn"
    let nomeBotaoLimpar = "btn_limpar"
    let nomeIngrediente = "ingrediente"
    let nomePrato = "prato"
    
    // MARK: - Ciclo de Vida
    
    override func didMove(to view: SKView) {
        
        viewModel.scene = self
        backgroundColor = .white
        self.scaleMode = .resizeFill
        
        physicsWorld.gravity = .zero
        view.showsPhysics = false
        
//        physicsManager = PhysicsManager(scene: self)
        // physicsWorld.contactDelegate = physicsManager
        
        viewModel.criarPratoRedondo()
        viewModel.criarBotoes()
    }
    
    
    
    
    
    
    
    // MARK: - Touch Handling (Drag & Drop Top-Down)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesTocados = nodes(at: location)
        
        
        for node in nodesTocados {
            if node.name == nomeBotaoSpawn { viewModel.spawnIngrediente(); return }
            if node.name == nomeBotaoLimpar { viewModel.limparTudo(); return }
        }
        
        // Lógica de Arrastar
        
       
        if let nodeTocado = nodesTocados.first(where: { node in
            
            if node.name == nomePrato { return true }
            
            if let nome = node.name, viewModel.opcoes.contains(nome) { return true }
            
            return false
        }) {
            
            // Verifica se o ingrediente já está no prato (Verifca qual o seu pai)
            if let parent = nodeTocado.parent, parent.name == nomePrato {
                // Então arrastamos o PRATO inteiro
                nodeSendoArrastado = pratoNode
                nodeSendoArrastado?.run(SKAction.scale(to: 1.1, duration: 0.1))
            }
            // Verifica se o objeto arrastado é o prato
            else if nodeTocado.name == nomePrato {
                nodeSendoArrastado = pratoNode
                nodeSendoArrastado?.run(SKAction.scale(to: 1.1, duration: 0.1))
            }
            // Ação caso seja um ingrediente está apenas solto na mesa
            else {
                nodeSendoArrastado = nodeTocado
                nodeSendoArrastado?.setScale(0.6)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let node = nodeSendoArrastado else { return }
        let location = touch.location(in: self)
        
        node.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.soltarObjeto(node: nodeSendoArrastado)
        
        nodeSendoArrastado = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.soltarObjeto(node: nodeSendoArrastado)
        nodeSendoArrastado = nil
    }
    
    

    
}
