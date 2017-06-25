//
//  Item.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/06/03.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class Item: Unit {
    
    convenience init(position: CGPoint) {
        self.init(imageNamed: "player")
        self.position = position
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody?.categoryBitMask = ContactCategory.item
        self.physicsBody?.contactTestBitMask = ContactCategory.player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collide(with _: UInt32) {
        removeFromParent()
    }
}
