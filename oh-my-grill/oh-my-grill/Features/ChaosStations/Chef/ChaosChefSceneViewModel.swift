//
//  ChefSceneViewModel.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 28/11/25.
//

import Foundation
import SpriteKit
import SwiftUI

class ChaosChefSceneViewModel {

    weak var scene: ChaosChefScene!

    let dishName = "dish"

    var dishNode: SKSpriteNode?

    private var cont = 0

    let options = ["burger-cheesed-shade", "tomato-sliced-shade", "lettuce-sliced-shade", "potato-cooked-shade", "bun-top-shade",  "bun-bottom-shade"]


    func createRoundedDish(isPotato: Bool = false) {
        let dishSize = isPotato ? CGSize(width: 100, height: 70) : CGSize(width: 140, height: 105)

        let dish = SKSpriteNode(color: .lightGray, size: dishSize)

        
        let roundedTexture = SKTexture(imageNamed: "dish")

        dish.texture = roundedTexture

        dish.color = .white

        dish.colorBlendFactor = 1.0

        

        dish.position = isPotato ? CGPoint(x: (scene.frame.maxX - CGFloat(240)), y: (scene.frame.midY  - CGFloat(30))) : CGPoint(x: (scene.frame.maxX - CGFloat(120)), y: (scene.frame.midY - CGFloat(30)))

        dish.name = dishName

        dish.zPosition = 0
        dish.physicsBody = SKPhysicsBody(circleOfRadius: dishSize.width / 2)

        dish.physicsBody?.isDynamic = false

        dish.physicsBody?.categoryBitMask = PhysicsCategory.plate

        

        scene.addChild(dish)

        self.dishNode = dish

    }
    
    func createIngredientComponent(name: String, ingredientPosition: CGFloat) {
        
        let size = name == "potato-cooked-shade" ? CGSize(width: 125  , height: 90) : CGSize(width: 90 , height: 90)
        
        let ingredient = SKSpriteNode(texture: SKTexture(imageNamed: name), color: .clear, size: size)
        ingredient.position = CGPoint(x: scene.frame.minX + ingredientPosition, y: scene.frame.minY + 50)


        let counter = SKShapeNode(rectOf:  CGSize(width: 23, height: 23), cornerRadius: 20)
        counter.position = CGPoint(x: scene.frame.minX + (ingredientPosition + 40), y: scene.frame.minY + 80)
        counter.fillColor = .texasCherry
        counter.strokeColor = .clear
        
        let label = SKLabelNode(text: "0")
        label.fontName = "Toy Block Maestro"
        label.fontSize = 15
        label.position = CGPoint(x: scene.frame.minX + (ingredientPosition + 40), y: scene.frame.minY + 73)

        scene.addChild(label)
        scene.addChild(counter)
        scene.addChild(ingredient)



    }
    
    func createBench() {
        
        var startX = CGFloat(100)
        let bench = SKShapeNode(rectOf: CGSize(width: 676, height: 96), cornerRadius: 8)
        
        bench.fillColor = .white
        bench.fillTexture = SKTexture.gradient(size: CGSize(width: 300, height: 100), colors: [.texasSalmon, .texasGrayGradient], startPoint: CGPoint(x: 0, y: 0), 
                                                 endPoint: CGPoint(x: 1, y: 3))
        
        bench.position = CGPoint(x: scene.frame.minX + 330, y: scene.frame.minY + 10)
        
        for ingrediente in options {
            
            createIngredientComponent(name: ingrediente, ingredientPosition: startX)
            startX += 100

        }

        scene.addChild(bench)
        
        
    }
    


}

