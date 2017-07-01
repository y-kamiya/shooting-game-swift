//
//  Player.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/05/23.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class Player: Unit {
    
    var velocity: Float = 3
    
    convenience init() {
        self.init(imageNamed: "player")
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody?.categoryBitMask = ContactCategory.player
        self.physicsBody?.contactTestBitMask = ContactCategory.wall + ContactCategory.enemy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func move(for direction: CGPoint) {
        let vel = CGFloat(velocity)
        let vecter = CGVector(dx: direction.x * vel, dy: direction.y * vel)
        run(SKAction.move(by: vecter, duration: 0.001))
    }
    
    public func shot() -> [Bullet] {
        return [Bullet(position: position)]
    }
    
    public func getItem() {
        velocity += 2
    }
    
    override func collide(with bitmask: UInt32) {
        if (bitmask == ContactCategory.item) {
            return getItem()
        }
        removeFromParent()
        NotificationCenter.default.post(name: Event.playerDead.name, object: nil)
    }
}
