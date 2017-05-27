//
//  Bullet.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/05/27.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: Unit {
    
    convenience init(position: CGPoint) {
        self.init(imageNamed: "projectile")
        self.position = position
        self.move()
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody?.categoryBitMask = ContactCategory.bullet
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func move() {
        let distPos = CGPoint(x: position.x, y: position.y + 1000)
        run(SKAction.sequence([
            SKAction.move(to: distPos, duration: 2.0)
          , SKAction.removeFromParent()
        ]))
    }
}
