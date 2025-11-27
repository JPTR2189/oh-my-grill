//
//  GameView.swift
//  oh-my-grill-POC
//
//  Created by Jean Pierre on 25/11/25.
//

import Foundation

import SwiftUI
import SpriteKit 

struct GameView: View {
    
    // 2. Criamos uma propriedade computada que configura a cena
    var scene: SKScene {
        // Inicializa a sua GameScene
        let scene = GameScene2()
        
        // Define o tamanho (use .resizeFill ou .aspectFill para telas diferentes)
        scene.scaleMode = .resizeFill
        
        // Cor de fundo inicial (opcional)
        scene.backgroundColor = .white
        
        return scene
    }

    var body: some View {
        // 3. A "TV" que exibe a cena
        SpriteView(scene: scene)
            .ignoresSafeArea() // Ocupa a tela inteira (remove bordas brancas)
    }
}
