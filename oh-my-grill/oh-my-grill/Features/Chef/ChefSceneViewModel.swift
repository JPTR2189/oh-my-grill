//
//  ChefSceneViewModel.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 28/11/25.
//

import Foundation
import SpriteKit
import SwiftUI

class ChefSceneViewModel {

    weak var scene: ChefScene!

    let nomePrato = "prato"

    var pratoNode: SKSpriteNode?

    private var cont = 0

    let opcoes = ["burger-cheesed-shade", "tomato-sliced-shade", "lettuce-sliced-shade", "potato-cooked-shade", "bun-top-shade",  "bun-bottom-shade"]


    func createRoundedDish(isPotato: Bool = false) {

        

        let tamanhoPrato = isPotato ? CGSize(width: 100, height: 70) : CGSize(width: 140, height: 105)

        let prato = SKSpriteNode(color: .lightGray, size: tamanhoPrato)

        
        let texturaRedonda = SKTexture(imageNamed: "dish")

        prato.texture = texturaRedonda

        prato.color = .white

        prato.colorBlendFactor = 1.0

        

        prato.position = isPotato ? CGPoint(x: (scene.frame.maxX - CGFloat(240)), y: (scene.frame.midY  - CGFloat(30))) : CGPoint(x: (scene.frame.maxX - CGFloat(120)), y: (scene.frame.midY - CGFloat(30)))

        prato.name = nomePrato

        prato.zPosition = 0

        

        

        prato.physicsBody = SKPhysicsBody(circleOfRadius: tamanhoPrato.width / 2)

        prato.physicsBody?.isDynamic = false

        prato.physicsBody?.categoryBitMask = PhysicsCategory.dish

        

        scene.addChild(prato)

        self.pratoNode = prato

    }
    
    func createIngredientComponent(nome: String, posicaoIngrediente: CGFloat) {
        
        let tamanho = nome == "potato-cooked-shade" ? CGSize(width: 125  , height: 90) : CGSize(width: 90 , height: 90)
        
        let ingrediente = SKSpriteNode(texture: SKTexture(imageNamed: nome), color: .clear, size: tamanho)
        ingrediente.position = CGPoint(x: scene.frame.minX + posicaoIngrediente, y: scene.frame.minY + 50)


        let contador = SKShapeNode(rectOf:  CGSize(width: 23, height: 23), cornerRadius: 20)
        contador.position = CGPoint(x: scene.frame.minX + (posicaoIngrediente + 40), y: scene.frame.minY + 80)
        contador.fillColor = .texasCherry
        contador.strokeColor = .clear
        
        let label = SKLabelNode(text: "0")
        label.fontName = "Toy Block Maestro"
        label.fontSize = 15
        label.position = CGPoint(x: scene.frame.minX + (posicaoIngrediente + 40), y: scene.frame.minY + 73)

        scene.addChild(label)
        scene.addChild(contador)
        scene.addChild(ingrediente)



    }
    
    func createBench() {
        
        var startX = CGFloat(100)
        let bancada = SKShapeNode(rectOf: CGSize(width: 676, height: 96), cornerRadius: 8)
        
        bancada.fillColor = .white
        bancada.fillTexture = SKTexture.gradient(size: CGSize(width: 300, height: 100), colors: [.texasSalmon, .texasGrayGradient], startPoint: CGPoint(x: 0, y: 0), 
                                                 endPoint: CGPoint(x: 1, y: 3))
        
        bancada.position = CGPoint(x: scene.frame.minX + 330, y: scene.frame.minY + 10)
        
        for ingrediente in opcoes {
            
            createIngredientComponent(nome: ingrediente, posicaoIngrediente: startX)
            startX += 100

        }

        scene.addChild(bancada)
        
        
    }
    


}

