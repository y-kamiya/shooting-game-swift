//
//  Field.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/06/17.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class Field: SKShapeNode, Collidable {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhysicsBody() {
        self.physicsBody = SKPhysicsBody(edgeChainFrom: self.path!)
        self.physicsBody?.categoryBitMask = ContactCategory.wall
        self.physicsBody?.collisionBitMask = ContactCategory.none
        self.physicsBody?.contactTestBitMask = ContactCategory.all
    }
    
    func collide(with _: UInt32) {
    }
}
