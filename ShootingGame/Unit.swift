//
//  Unit.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/05/22.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class Unit: SKSpriteNode {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
