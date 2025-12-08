//
//  SKTexture.swift
//  oh-my-grill
//
//  Created by Jean Pierre on 02/12/25.
//

import Foundation
import SpriteKit

extension SKTexture {
    static func gradient(size: CGSize, colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) -> SKTexture {
        
        // 1. Cria uma camada de gradiente do Core Animation
        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: .zero, size: size)
        layer.colors = colors.map { $0.cgColor }
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        
        // 2. Renderiza essa camada em uma Imagem
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return SKTexture() }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 3. Retorna como textura do SpriteKit
        return SKTexture(image: image ?? UIImage())
    }
}
