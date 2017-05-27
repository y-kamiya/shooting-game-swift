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
        let distPos = position + direction * 10
        run(SKAction.move(to: distPos, duration: 0.1))
    }
}
