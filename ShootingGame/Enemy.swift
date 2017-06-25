//
//  Enemy.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/05/22.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: Unit {
    
    private let ENEMY_SPEED_Y: Float = 100
    
    convenience init(frame: CGRect) {
        self.init(imageNamed: "monster")
        let x = CGFloat(arc4random() % UInt32(frame.width))
        self.position = CGPoint(x:x, y:frame.height)
        self.move()
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody?.categoryBitMask = ContactCategory.enemy
        self.physicsBody?.contactTestBitMask = ContactCategory.bullet
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func move() {
        let duration = Float(position.y) / ENEMY_SPEED_Y
        run(SKAction.move(to: CGPoint(x:position.x, y:-100), duration: TimeInterval(duration)))
    }
    
    override func collide(with mask: UInt32) {
        removeFromParent()
        if (mask == ContactCategory.wall) {
            return
        }
        NotificationCenter.default.post(name: Event.enemyDead.name, object: nil)
    }
    
}
