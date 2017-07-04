//
//  BulletSkewRight.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/07/04.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class BulletSkewRight: Bullet {
    
    convenience init(from position: CGPoint) {
        self.init(imageNamed: "bulletSkewRight")
        self.position = position
        self.move()
    }
    
    private func move() {
        let direction = CGPoint(x: 1.0, y: 1.0)
        let distPos = position + direction * 1000
        run(SKAction.sequence([
            SKAction.move(to: distPos, duration: 2.0)
          , SKAction.removeFromParent()
        ]))
    }
}
