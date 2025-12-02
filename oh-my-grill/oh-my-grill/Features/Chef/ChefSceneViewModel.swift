//
//  ChefSceneViewModel.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 28/11/25.
//

import Foundation
import SpriteKit

class ChefSceneViewModel {

    weak var scene: ChefScene!

    

    let nomeBotaoSpawn = "btn_spawn"

    let nomeBotaoLimpar = "btn_limpar"

    let nomeIngrediente = "ingrediente"

    let nomePrato = "prato"

    var nodeSendoArrastado: SKNode?

    

    

    var nívelDeEmpilhamentoAtual: CGFloat = 10

    

    // Referência ao prato para sabermos onde é o centro

    var pratoNode: SKSpriteNode?

    

    private var cont = 0

    let opcoes = ["burger-cheesed", "tomato-sliced", "lettuce-sliced", "potato-fried", "bun-top",  "bun-bottom"]

    

    let tituloBotaoSpawn = "+ Comida"

    let tituloBotaoLimpar = "Limpar"

    

    // Identificadores para a View usar

    let idBotaoSpawn = "btn_spawn"

    let idBotaoLimpar = "btn_limpar"

    let idIngrediente = "ingrediente"

    

    

    // Se quiser mudar a física do jogo, muda só aqui!

    let gravidade = CGVector(dx: 0, dy: -9.8)

    let escalaPadraoIngrediente: CGFloat = 0.5

    let tamanhoFallback = CGSize(width: 60, height: 20)

    

    // Define o intervalo do empurrãozinho lateral

    let rangeImpulso: ClosedRange<CGFloat> = -5...5

    

    

    func getNextIngredientName() -> String {

        let ingrediente = opcoes[cont]

        cont = (cont + 1) % opcoes.count

        return ingrediente

    }

    

    func spawnIngrediente() {

        let nomeSorteado = getNextIngredientName()

        

        var node = SKSpriteNode(imageNamed: nomeSorteado)

        

        if nomeSorteado == "bun-bottom"  {

            let textura = SKTexture(imageNamed: "bun-bottom")

            

            node = SKSpriteNode(texture: textura, color: .clear, size: CGSize(width: 155 , height: 155))

        } else if nomeSorteado == "tomato-sliced" {

            let textura = SKTexture(imageNamed: "tomato-sliced")

            

            node = SKSpriteNode(texture: textura, color: .clear, size: CGSize(width: 130, height: 130))

        }

        

        node.name = nomeSorteado

        

        //        node.anchorPoint = CGPoint(x: 0., y: 0.5)

        

        if node.texture == nil {

            node.color = .yellow

            node.size = CGSize(width: 60, height: 60)

        } else {

            node.setScale(0.5)

        }

        


        // Definimos os limites desejados

        let minX = scene.frame.maxX - 550

        let maxX = scene.frame.maxX - 400

        let minY = scene.frame.midY + 80  // Um pouco acima do centro

        let maxY = scene.frame.maxY - 120 // Um pouco abaixo do topo

        

        var posX: CGFloat = 0

        var posY: CGFloat = 0

        

        // Verificação de Segurança EIXO X

//        if minX < maxX {

            posX = CGFloat.random(in: minX...maxX)

//        } else {

//            posX = scene.frame.midX

//        }

        

        // Verificação de Segurança EIXO Y

//        if minY < maxY {

//            posY = CGFloat.random(in: minY...maxY)

//        } else {

            posY = scene.frame.maxY - 100

//        }

        

        node.position = CGPoint(x: posX, y: posY)

        

        

        

        // Coloca em cima de tudo

        node.zPosition = 100

        

        // Adiciona na CENA (Solto)

        scene.addChild(node)

        

        // Cria uma animação de entrada

        node.setScale(0.1)

        node.run(SKAction.scale(to: 0.5, duration: 0.2))

    }

    

    func criarPratoRedondo() {

        

        let tamanhoPrato = CGSize(width: 150, height: 150)

        let prato = SKSpriteNode(color: .lightGray, size: tamanhoPrato)

        

        

        let texturaRedonda = SKTexture(imageNamed: "dish")

        prato.texture = texturaRedonda

        prato.color = .white

        prato.colorBlendFactor = 1.0

        

        prato.position = CGPoint(x: (scene.frame.maxX - CGFloat(200)), y: scene.frame.midY)

        prato.name = nomePrato

        prato.zPosition = 0

        

        

        prato.physicsBody = SKPhysicsBody(circleOfRadius: tamanhoPrato.width / 2)

        prato.physicsBody?.isDynamic = false

        prato.physicsBody?.categoryBitMask = PhysicsCategory.prato

        

        scene.addChild(prato)

        self.pratoNode = prato

    }
    
    func componenteIngrediente(nome: String, posicaoIngrediente: CGFloat) {
        
        let tamanho = nome == "potato-fried" ? CGSize(width: 100  , height: 65) : CGSize(width: 65 , height: 65)
        
        let ingrediente = SKSpriteNode(texture: SKTexture(imageNamed: nome), color: .clear, size: tamanho)
        ingrediente.position = CGPoint(x: scene.frame.minX + posicaoIngrediente, y: scene.frame.minY + 50)

        let contador = SKShapeNode(rectOf:  CGSize(width: 23, height: 23), cornerRadius: 20)
        contador.position = CGPoint(x: scene.frame.minX + (posicaoIngrediente + 40), y: scene.frame.minY + 80)
        contador.fillColor = .texasCherry
        
        let label = SKLabelNode(text: "0")
        label.fontName = "Toy Block Maestro"
        label.fontSize = 15
        label.position = CGPoint(x: scene.frame.minX + (posicaoIngrediente + 40), y: scene.frame.minY + 73)

        scene.addChild(ingrediente)
        scene.addChild(contador)
        scene.addChild(label)



    }
    
    func criarBancada() {
        
        var startX = CGFloat(100)
        let bancada = SKShapeNode(rectOf: CGSize(width: 676, height: 96), cornerRadius: 8)
        
        bancada.fillColor = .texasSalmon
        bancada.position = CGPoint(x: scene.frame.minX + 330, y: scene.frame.minY + 10)
        
        for ingrediente in opcoes {
            
            componenteIngrediente(nome: ingrediente, posicaoIngrediente: startX)
            startX += 100

        }
        
        

        

        
        
        

        scene.addChild(bancada)
        
        
    }

    func criarBotoes() {

        

        let btnSpawn = SKSpriteNode(color: .systemGreen, size: CGSize(width: 100, height: 50))

        btnSpawn.position = CGPoint(x: scene.frame.minX + 80, y: scene.frame.minY + 100)

        btnSpawn.name = nomeBotaoSpawn

        btnSpawn.zPosition = 100

        

        let labelSpawn = SKLabelNode(text: "+ Comida")

        labelSpawn.fontSize = 14

        labelSpawn.fontName = "Helvetica-Bold"

        labelSpawn.verticalAlignmentMode = .center

        labelSpawn.name = nomeBotaoSpawn

        btnSpawn.addChild(labelSpawn)

        scene.addChild(btnSpawn)

        

        

        let btnLimpar = SKSpriteNode(color: .systemRed, size: CGSize(width: 100, height: 50))

        btnLimpar.position = CGPoint(x: scene.frame.minX + 250, y: scene.frame.minY + 100)

        btnLimpar.name = nomeBotaoLimpar

        btnLimpar.zPosition = 100

        

        let labelLimpar = SKLabelNode(text: "Limpar")

        labelLimpar.fontSize = 14

        labelLimpar.fontName = "Helvetica-Bold"

        labelLimpar.verticalAlignmentMode = .center

        labelLimpar.name = nomeBotaoLimpar

        btnLimpar.addChild(labelLimpar)

        scene.addChild(btnLimpar)

    }
    
    

    

    func limparTudo() {

        // Procura os filhos dentro do prato e remove eles

        pratoNode?.removeAllChildren()

        

        // Reinicia o contador

        nívelDeEmpilhamentoAtual = 10

        

    }

    

    

    func soltarObjeto(node: SKNode?) {

        guard let node = node as? SKSpriteNode else { return }

        guard let prato = pratoNode else { return }

        

        

        

        // se soltamos um INGREDIENTE

        if  opcoes.contains(node.name!) {

            

            if node.parent != prato {

                

                let distancia = node.position.distance(to: prato.position)

                

                if distancia < 60 {

                    

                    node.removeFromParent()

                    prato.addChild(node)

                    

                    

                    

                    let breadTop = node.name == "bun-top"

                    

                    if breadTop {

                        print("PAO DE CIMA")

                        node.anchorPoint = CGPoint(x: 0.515, y: 0.5)

                    } else {

                        print("SEMMM PAO DE CIMA")

                        

                        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)

                    }

                    // --------------------------------------------------

                    

                    // Cálculo da Perspectiva

                    let indiceDaCamada = nívelDeEmpilhamentoAtual - 10

                    let alturaPorItem: CGFloat = 5.0

                    let novaPosicaoY = indiceDaCamada * alturaPorItem

                    

                    // Aplica a posição. X é ZERO para alinhar no centro do prato.

                    node.position = CGPoint(x: 0, y: novaPosicaoY)

                    

                    // Ajusta Z e incrementa nível

                    node.zPosition = nívelDeEmpilhamentoAtual

                    nívelDeEmpilhamentoAtual += 1

                    

                    // Animação de encaixe

                    node.setScale(0.5)

                    node.run(SKAction.sequence([

                        SKAction.scale(to: 0.57, duration: 0.05),

                        SKAction.scale(to: 0.5, duration: 0.05)

                    ]))

                    

                } else {

                    // Soltou longe

                    node.setScale(0.5)

                    // Garante o anchor point central se soltar na mesa também

                    node.anchorPoint = CGPoint(x: 0.5, y: 0.5)

                }

            }

        }

    }

    

}

