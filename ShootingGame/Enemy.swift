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
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody?.categoryBitMask = ContactCategory.enemy
        self.physicsBody?.contactTestBitMask = ContactCategory.bullet
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}