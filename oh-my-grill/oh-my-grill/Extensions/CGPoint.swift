//
//  CGPoint.swift
//  oh-my-grill-POC
//
//  Created by Jean Pierre on 25/11/25.
//

import Foundation
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
}
